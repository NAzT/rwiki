module Rwiki
  class App < Sinatra::Base

    set :root, File.join(File.dirname(__FILE__), '../..')
    set :app_file, File.join(File.dirname(__FILE__), '../../..')

    include SmartAsset::Adapters::Sinatra
    
    disable :show_exceptions
    enable :raise_errors
    enable :logging

    configure do
      Dir.mkdir('log') unless File.exists?('log')
    end

    configure :test do
      use Rack::CommonLogger, File.new('log/test.log', 'w')
    end

    configure :development do
      use Rack::CommonLogger, File.new('log/development.log', 'w')
    end

    error NodeNotFoundError do
      message = request.env['sinatra.error'].message
      { :success => false, :message => message }.to_json
    end

    get '/' do
      erb :index
    end

    get '/nodes' do
      Node.tree.to_json
    end

    get '/node' do
      path = params[:path].strip
      page = Node.new(path)

      page.to_json
    end

    # update page content
    put '/node' do
      path = params[:path].strip
      raw_content = params[:rawContent].force_encoding("UTF-8")

      page = Node.new(path)
      page.raw_content = raw_content
      page.save

      page.to_json
    end

    # create a new node
    post '/node' do
      parent_path = params[:parentPath].strip
      name = params[:name].strip

      parent_folder = Node.new(parent_path)
      if params[:isFolder] == 'true'
        node = parent_folder.create_sub_folder(name)
      else
        node = parent_folder.create_sub_page(name)
      end

      node.to_json
    end

    post '/node/rename' do
      path = params[:path].strip
      new_name = params[:newName].strip

      node = Node.new_from_path(path)
      node.rename(new_name)

      result = node.to_hash
      result[:oldPath] = path

      result.to_json
    end

    put '/node/move' do
      path = params[:path].strip
      new_parent_path = params[:newParentPath].strip

      node = Node.new_from_path(path)
      new_parent = Node.new_from_path(new_parent_path)
      node.move(new_parent)

      result = node.to_hash
      result[:oldPath] = path
      result[:success] = true

      result.to_json
    end

    delete '/node' do
      path = params[:path].strip
      node = Node.new_from_path(path)
      node.delete

      { :path => node.path }.to_json
    end

    get '/fuzzy_finder' do
      query = params[:query]
      matches = Node.fuzzy_finder(query)

      { :results => matches, :count => matches.size }.to_json
    end

    get '/node/print' do
      path = params[:path].strip
      page = Node.new(path)
      @html = page.to_html

      erb :print, :layout => false
    end
  end
end
