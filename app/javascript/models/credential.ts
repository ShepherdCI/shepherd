import { Model, BelongsTo, Attr } from 'jsorm'
import { ApplicationRecord } from './application-record'
import { User } from './user'

@Model()
export class Credential extends ApplicationRecord {
  @Attr() jwt : string
  @BelongsTo() user : User
}
