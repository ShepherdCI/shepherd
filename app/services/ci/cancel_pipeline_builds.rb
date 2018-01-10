class Ci::CancelPipelineBuilds
  include CallableService

  attribute :pipeline, Ci::Pipeline

  def call
    pipeline.builds.in_progress.all? do |build|
      build.cancel
    end
  end
end
