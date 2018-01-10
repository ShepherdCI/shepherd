class UpdateBuildStatus
  include CallableService

  attribute :build, Ci::Build
  attribute :params, Hash

  def call
    build.update_attributes(trace: params['trace']) if params['trace']

    # BroadcastBuildStatus.call(build: build)
  end
end
