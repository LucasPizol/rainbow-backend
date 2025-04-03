# frozen_string_literal: true

require 'spec_helper'

action_to_method = {
  index: :get,
  show: :get,
  create: :post,
  update: :put,
  destroy: :delete
}

RSpec.shared_examples 'is not routable' do |path, method|
  it { expect(method => path).not_to be_routable }
end

RSpec.shared_examples 'is routable' do |path, method, action, params|
  it { expect(method => "#{path}##{action}").to route_to({ format: :json, controller: controller[1..], action: action.to_s }.merge(params || {})) }
end

RSpec.shared_examples 'routes' do |route:, actions: [], controller: nil|
  let(:controller) { controller || route }
  resource_id = rand(10..99)

  actions.each do |action|
    if [:show, :update, :destroy].include?(action)
      describe "##{action} action" do
        if actions.include?(action)
          it_behaves_like 'is routable', "#{route}/#{resource_id}", action_to_method[action], action, { id: resource_id.to_s }
        else
          it_behaves_like 'is not routable', "#{route}/#{resource_id}", action_to_method[action]
        end
      end
    else
      describe "##{action} action" do
        if actions.include?(action)
          it_behaves_like 'is routable', "#{route}", action_to_method[action], action
        else
          it_behaves_like 'is not routable', "#{route}", action_to_method[action]
        end
      end
    end
  end
end

RSpec.shared_examples 'unauthenticated' do
  let(:params) { { id: 999 } }

  context 'when the user is not authenticated' do
    it { is_expected.to have_http_status(:unauthorized) }
    it 'does not return data' do
      subject

      expect(json_response).to match({ error: 'Você precisa fazer login ou se cadastrar antes de continuar.' })
    end
  end
end
