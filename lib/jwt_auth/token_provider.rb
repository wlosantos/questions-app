module JwtAuth
  class TokenProvider
    ALGORITHM = 'HS256'.freeze

    def self.issue_token(payload)
      JWT.encode(payload, secret_key, ALGORITHM)
    end

    def self.decode_token(token)
      JWT.decode(token, secret_key, true, algorithm: ALGORITHM)[0]
    rescue JWT::DecodeError => e
      raise ExceptionHandler::InvalidToken, e.message
    end

    def self.valid_payload(payload)
      return false unless payload['email']
    end

    def self.secret_key
      Rails.application.secrets.secret_key_base.to_s.freeze
    end
  end
end
