# frozen_string_literal: true

RSpec.shared_examples 'error instance' do
  let(:response) do
    Net::HTTPBadRequest.new(nil, 400, 'Bad Request').tap do |res|
      res.content_type = content_type if content_type
      allow(res).to receive(:body).and_return(res_body)
    end
  end
  subject { MSGraph::Error.new(response) }
  it {
    is_expected.to have_attributes(
      response: response, body: error_body, error: error_obj
    )
  }
end

RSpec.describe MSGraph::Error do
  context 'with a json response' do
    let(:err_obj) { { code: 'error code' } }
    let(:res_obj) { { error: err_obj } }
    let(:res_body) { JSON.dump(res_obj) }
    let(:content_type) { 'application/json;' }
    include_examples 'error instance' do
      let(:error_body) { res_obj }
      let(:error_obj) { err_obj }
    end
  end
  context 'with a text response' do
    let(:res_body) { 'Invalid Error!' }
    let(:content_type) { nil }
    include_examples 'error instance' do
      let(:error_body) { res_body }
      let(:error_obj) { nil }
    end
  end
end
