require 'project_metric_pivotal_tracker'

describe ProjectMetricPivotalTracker, :vcr do
  let(:raw_data){nil}
  let(:subject){ProjectMetricPivotalTracker.new({project: '742821' , token: ENV["PIVOTAL_TRACKER_API_TOKEN"]}, raw_data)}
  let(:svg) { File.read './spec/data/sample.svg' }
  context 'LocalSupport' do
    describe '#refresh' do
      it 'fetches raw data' do
        subject.refresh
        expect(subject.raw_data).to eq({:done=>317, :new=>15, :old=>12, :older=>237, :total=>581})
      end
    end
    describe '#score' do
      it 'fetches raw data and computes score' do
        expect(subject.score).to eq 0.5636833046471601
      end
    end
    describe '#raw_data' do
      let(:raw_data){{:done=>317, :new=>15, :old=>12, :older=>237, :total=>581}}
      it 'sets raw_data in constructor' do
        expect(subject.raw_data).to eq raw_data
      end
    end
    describe '#raw_data=' do
      let(:raw_data_outside_constructor){{:done=>240, :new=>15, :old=>12, :older=>237, :total=>504}}
      let(:svg_two) { File.read './spec/data/sample_two.svg' }
      it 'sets raw_data when setter is called' do
        subject.raw_data = raw_data_outside_constructor
        expect(subject.raw_data).to eq raw_data_outside_constructor
      end
      it 'unsets score when called' do
        expect(subject.score).to eq 0.5636833046471601
        subject.raw_data = raw_data_outside_constructor
        expect(subject.score).to eq 0.49702380952380953
      end
      it 'unsets image when called' do
        #expect(subject.image).to eq svg
        subject.raw_data = raw_data_outside_constructor
        expect(subject.image).to eq svg_two
      end
    end
    describe 'image' do
      it 'constructs appropriate image' do
        expect(subject.image).to eq svg
      end
    end
  end
end