module Ci
  class CreateBuildsForCommit
    include CallableService

    attribute :commit, Ci::Commit
    attribute :base_repo, Repo
    attribute :ci_service, CiService
    attribute :ref, String
    attribute :stage, String
    attribute :previous_stage_status, String, default: 'success'
    attribute :tag, String
    attribute :clone_url, String

    def call
      config = commit.config_processor

      build_configs = config.builds_for_stage_and_ref(stage, ref, tag)

      build_configs.select! do |build|
        case build[:when]
        when 'on_success'
          previous_stage_status == 'success'
        when 'on_failure'
          previous_stage_status == 'failed'
        when 'always'
          %w(success failed).include?(previous_stage_status)
        end
      end

      build_configs.map do |build_config|
        # don't create the same build twice
        unless commit.builds.find_by(ref: ref, tag: tag, name: build_config[:name])
          build_config.slice!(:name,
                             :description,
                             :commands,
                             :tag_list,
                             :options,
                             :allow_failure,
                             :stage,
                             :stage_idx)

          build_config.merge!(ref: ref,
                             tag: tag,
                             repo: base_repo,
                             clone_url: clone_url,
                             ci_service: ci_service)

          build = commit.builds.create!(build_config)
          build.update_commit_status
          build
        end
      end
    end
  end
end
