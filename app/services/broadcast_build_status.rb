class BroadcastBuildStatus
  include CallableService

  attribute :build, Ci::Build

  def call
    ActionCable.server.broadcast "builds",
      build_id: build.id,
      details_html: ApplicationController.render(
        partial: 'ci/builds/build_details',
        locals: { build: build }
      )
  end
end
