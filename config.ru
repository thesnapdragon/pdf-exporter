require 'rails'
require 'action_controller/railtie'
require 'wicked_pdf'
require 'securerandom'

class PDFExporter < Rails::Application
  routes.append do
    get '/pdf/export'
  end

  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = true

  config.middleware.delete 'Rack::Lock'
  config.middleware.delete 'ActionDispatch::Flash'
  config.middleware.delete 'ActionDispatch::BestStandardsSupport'

  config.secret_token = '26jvwBTwjXdlSagQa98PoZcGtNaFEL9ESBiOGTQgx2kxU71llsgp2QFFyGSsXLgzR3hEVMn0Yq3iaar53gQyWJalpAvuqvYDnslT'

  config.pdf_path = Rails.env.production? ? '/pdfs' : '/tmp'
end

class PdfController < ActionController::Metal
  include ActionController::Head
  def export
    pdf = WickedPdf.new.pdf_from_url(params[:url], javascript_delay: 5000)
    uuid = SecureRandom.uuid
    file_name = uuid + '.pdf'
    save_path = File.join Rails.configuration.pdf_path, file_name
    File.open(save_path, 'wb') { |file| file << pdf }
    export_url = request.base_url + '/pdf/' + uuid + '/exported.pdf'
    head :created, location: export_url
  end
end

PDFExporter.initialize!
run PDFExporter
