# frozen_string_literal: true

require 'spec_helper'
require 'tempfile'
require 'json'

RSpec.describe DangerPrComment::Reporter do
  let(:status_report) do
    {
      errors: ['Error 1', 'Error 2'],
      warnings: ['Warning 1'],
      messages: ['Message 1'],
      markdowns: ['Markdown 1']
    }
  end

  subject(:reporter) { described_class.new(status_report) }

  describe '#initialize' do
    it 'stores the status report' do
      expect(reporter.instance_variable_get(:@status_report)).to eq(status_report)
    end
  end

  describe '#export_json' do
    let(:event_data) do
      {
        'pull_request' => {
          'number' => 123
        }
      }
    end

    let(:event_file) { Tempfile.new(['event', '.json']) }
    let(:report_file) { Tempfile.new(['report', '.json']) }

    before do
      event_file.write(JSON.generate(event_data))
      event_file.close
    end

    after do
      event_file.unlink
      report_file.unlink
    end

    context 'when all parameters are valid' do
      it 'creates a JSON report file' do
        reporter.export_json(report_file.path, event_file.path)

        expect(File.exist?(report_file.path)).to be true
      end

      it 'includes the PR number in the report' do
        reporter.export_json(report_file.path, event_file.path)

        report = JSON.parse(File.read(report_file.path))
        expect(report['pr_number']).to eq(123)
      end

      it 'includes errors in the report' do
        reporter.export_json(report_file.path, event_file.path)

        report = JSON.parse(File.read(report_file.path))
        expect(report['errors']).to eq(['Error 1', 'Error 2'])
      end

      it 'includes warnings in the report' do
        reporter.export_json(report_file.path, event_file.path)

        report = JSON.parse(File.read(report_file.path))
        expect(report['warnings']).to eq(['Warning 1'])
      end

      it 'includes messages in the report' do
        reporter.export_json(report_file.path, event_file.path)

        report = JSON.parse(File.read(report_file.path))
        expect(report['messages']).to eq(['Message 1'])
      end

      it 'includes markdowns in the report' do
        reporter.export_json(report_file.path, event_file.path)

        report = JSON.parse(File.read(report_file.path))
        expect(report['markdowns']).to eq(['Markdown 1'])
      end

      it 'formats the JSON with pretty_generate' do
        reporter.export_json(report_file.path, event_file.path)

        content = File.read(report_file.path)
        expect(content).to include("\n")
        expect(content).to match(/\{\n/)
      end
    end

    context 'when report_path is nil' do
      it 'does not create a report file' do
        original_content = File.exist?(report_file.path) ? File.read(report_file.path) : nil

        reporter.export_json(nil, event_file.path)

        if File.exist?(report_file.path)
          expect(File.read(report_file.path)).to eq(original_content)
        end
      end
    end

    context 'when event_path is nil' do
      it 'does not create a report file' do
        reporter.export_json(report_file.path, nil)

        expect(File.size(report_file.path)).to eq(0)
      end
    end

    context 'when event file does not exist' do
      it 'does not create a report file' do
        reporter.export_json(report_file.path, '/nonexistent/path.json')

        expect(File.size(report_file.path)).to eq(0)
      end
    end

    context 'when event file has no PR number' do
      let(:event_data) { { 'some_other_key' => 'value' } }

      it 'does not create a report file' do
        reporter.export_json(report_file.path, event_file.path)

        expect(File.size(report_file.path)).to eq(0)
      end
    end

    context 'when status report items respond to :message' do
      let(:message_object) do
        Class.new do
          def message
            'Object message'
          end
        end.new
      end

      let(:status_report) do
        {
          errors: [message_object],
          warnings: [],
          messages: [],
          markdowns: []
        }
      end

      it 'extracts the message from objects' do
        reporter.export_json(report_file.path, event_file.path)

        report = JSON.parse(File.read(report_file.path))
        expect(report['errors']).to eq(['Object message'])
      end
    end

    context 'when status report values are nil' do
      let(:status_report) do
        {
          errors: nil,
          warnings: nil,
          messages: nil,
          markdowns: nil
        }
      end

      it 'converts nil values to empty arrays' do
        reporter.export_json(report_file.path, event_file.path)

        report = JSON.parse(File.read(report_file.path))
        expect(report['errors']).to eq([])
        expect(report['warnings']).to eq([])
        expect(report['messages']).to eq([])
        expect(report['markdowns']).to eq([])
      end
    end
  end
end
