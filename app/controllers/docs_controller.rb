require 'jsonapi_swagger_helpers'

class DocsController < ActionController::API
  include JsonapiSwaggerHelpers::DocsControllerMixin

  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'ShepherdCI'
      key :description, '--'
      contact do
        key :name, 'Wade Tandy <wade.tandy@gmail.com>'
        key :email, 'wade.tandy@gmail.com'
      end
    end
    key :basePath, '/api'
    key :consumes, ['application/json']
    key :produces, ['application/json']
  end
  jsonapi_resource '/v1/credentials'
end
