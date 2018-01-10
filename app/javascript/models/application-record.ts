import { JSORMBase, Model } from 'jsorm'

export const JWT_STORAGE_TOKEN = 'jwt'

@Model({
  baseUrl: '',
  apiNamespace: '/api/v1',
  jwtLocalStorage: JWT_STORAGE_TOKEN
})
export class ApplicationRecord extends JSORMBase {}
