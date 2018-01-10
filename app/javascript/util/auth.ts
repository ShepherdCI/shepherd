import * as decode from 'jwt-decode'
import { JsonapiResponseDoc } from 'jsorm'
import { NavigationGuard } from 'vue-router'

import router from '../router'
import { ApplicationRecord } from '../models/application-record'
import { Credential } from '../models/credential'
import { User } from '../models/user'
import { JsonapiError, JsonapiResourceDoc, JsonapiResource } from 'jsorm'

export const OAUTH_PATH = '/auth/github'

const requireAuth : NavigationGuard = function (to, from, next) {
  if (!isLoggedIn()) {
    next({
      path: '/',
      query: { redirect: to.fullPath }
    });
  } else {
    next();
  }
}

export async function login(redirectPath? : string) {
  let success = await authenticateWithGithub()

  if (success) {
    if (redirectPath) {
      router.push(redirectPath)
    }
  }
}

function authenticateWithGithub(scope? : string) {
  let listener : (event : MessageEvent) => void
  let childIntervalTimer : number

  function removeListener() {
    window.removeEventListener('message', listener)
  }

  return new Promise<boolean>((resolve, reject) => {
    let success = false
    let authWindow = window.open(OAUTH_PATH, 'ShepherdOauthWindow', 'width=500,height=750')

    function checkChild() { 
      if (!authWindow || authWindow.closed) {
        clearInterval(childIntervalTimer)
        if (!success) {
          reject(new Error('Auth window closed by user'))
        }
      }
    }
    childIntervalTimer = setInterval(checkChild, 500);

    listener = (event : MessageEvent) => {
      try {
        if (event.origin && event.origin !== (<any>window).origin) {
          return
        }

        if (event.data.type !== 'OauthResponse') {
          return
        }

        let response : JsonapiResponseDoc = event.data.payload

        if (response.errors) {
          let messages : Array<string>= []

          response.errors.forEach((error) => {
            if(error.detail) {
              messages.push(error.detail)
            }
          }) 

          reject(new Error(`Error logging in: ${messages.join(', ')}`))
        } else {
          let credential : Credential = Credential.fromJsonapi(
            response.data as JsonapiResource, 
            response
          )

          handleLogin(credential)
          removeListener()
          success = true
          resolve(success)
        }
      } catch (e) {
        reject(e)
      }
    }

    window.addEventListener('message', listener)
  }).catch((err) => {
    try {
      removeListener() 
      clearInterval(childIntervalTimer)
    } catch(e) { }
       
    return Promise.reject(err)
  })
}

export function logout() {
  clearAccessToken();
  setUser(undefined)
  runLogoutHandlers()
  router.push('/')
}

function setAccessToken(token : string | null) {
  return ApplicationRecord.setJWT(token)
}

function clearAccessToken() {
  setAccessToken(null)
}

export function getAccessToken() {
  return ApplicationRecord.getJWT()
}

const loginHandlers : Function[] = []
export function onLogin(cb : () => void) {
  loginHandlers.push(cb)
}
function handleLogin(credential : Credential) {
  setAccessToken(credential.jwt)
  setUser(credential.user)
  loginHandlers.forEach((cb) => cb())
}

const logoutHandlers : Function[] = []
export function onLogout(cb : () => void) {
  logoutHandlers.push(cb)
}
function runLogoutHandlers() {
  logoutHandlers.forEach((cb) => cb())
}

let initializedLogin = false
export function isLoggedIn() {
  try {
    if (!initializedLogin) {
      loadCurrentUser()
    }
    const accessToken = getAccessToken();
    return !!accessToken && !isTokenExpired(accessToken);
  } catch(e) {
    console.debug('Error checking login status', e)
    return false
  }
}

function getTokenExpirationDate(encodedToken : string) {
  const token : any = decode(encodedToken)
  if (!token.exp) { return null; }

  const date = new Date(0);
  date.setUTCSeconds(token.exp);

  return date;
}

function isTokenExpired(token : string) {
  const expirationDate = getTokenExpirationDate(token);
  return expirationDate && expirationDate < new Date();
}

let _currentUser : User | undefined = undefined
function setUser(user : User | undefined) {
  if (user) {
    localStorage.setItem('currentUser', JSON.stringify(user.attributes))
  }

  _currentUser = user
}

function loadCurrentUser() {
  initializedLogin = true
  let userRecord = localStorage.getItem('currentUser')

  if (userRecord) {
    let user = new User(JSON.parse(userRecord))
    setUser(user)
  }
}

export function currentUser() {
  if (!initializedLogin) {
    loadCurrentUser()
  }
  return _currentUser
}