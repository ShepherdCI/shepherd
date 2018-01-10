module Github
  class Commit
    include Virtus.model
    include Github::ModelSync

    attribute :sha, String
    attribute :message, String
    attribute :timestamp, DateTime
    attribute :author, Hash
    attribute :tag, Boolean
    attribute :committer, Hash

    def self.shepherd_model
      Ci::Commit
    end

    def self.from_push_event_payload(payload)
      attrs = payload.dup

      attrs['sha'] = attrs.delete('id')

      self.new(attrs)
    end

    def tag?
      !!self.tag
    end

    def to_shepherd_attrs
      {
        sha: self.sha,
        tag: self.tag?,
        message: self.message,
        committed_at: self.timestamp,
        author_name: self.author[:name],
        author_email: self.author[:email],
        author_username: self.author[:username],
      }
    end
  end
end
