module Ci
  # This class responsible for assigning
  # proper pending build to runner on runner API request
  class RegisterBuildService
    def execute(current_runner)
      return unless current_runner.active?

      builds = Ci::Build.pending.unstarted

      builds =
        if current_runner.shared?
          # don't run projects which have not enables shared runners
          builds.joins(:ci_service).merge(CiService.shared_runners_enabled)
        else
          # do run projects which are only assigned to this runner
          # builds.where(repo: current_runner.repos.where(builds_enabled: true))
          ci_service = current_runner.ci_service
          builds.where(ci_service: ci_service)
        end

      builds = builds.order('created_at ASC')

      build = builds.find do |build|
        current_runner.can_pickup_build?(build)
      end

      if build
        # In case when 2 runners try to assign the same build, second runner will be declined
        # with StateMachines::InvalidTransition in run! method.
        build.with_lock do
          build.runner_id = current_runner.id
          build.save!
          build.run!
        end
      end

      build

    rescue StateMachines::InvalidTransition
      nil
    end
  end
end
