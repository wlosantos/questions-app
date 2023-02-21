# frozen_string_literal: true

RSpec::Matchers.define :permit do |action|
  match do |policy|
    policy.public_send("#{action}?")
  end

  failure_message do |policy|
    "expected to permit #{action} on #{policy}"
  end

  failure_message_when_negated do |policy|
    "expected not to permit #{action} on #{policy}"
  end
end
