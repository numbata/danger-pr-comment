# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DangerPrComment do
  describe 'VERSION' do
    it 'has a version number' do
      expect(DangerPrComment::VERSION).not_to be_nil
    end

    it 'is a string' do
      expect(DangerPrComment::VERSION).to be_a(String)
    end

    it 'follows semantic versioning format' do
      expect(DangerPrComment::VERSION).to match(/^\d+\.\d+\.\d+/)
    end
  end
end
