import { Model, Attr } from 'jsorm'
import { ApplicationRecord } from './application-record'

@Model()
export class User extends ApplicationRecord {
  @Attr name : string
  @Attr githubLogin : string
  @Attr avatarUrl : string
}
