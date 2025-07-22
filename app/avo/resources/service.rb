class Avo::Resources::Service < Avo::BaseResource
  self.title = :name
  # self.includes = []
  # self.attachments = []
  self.default_view_type = :grid
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }
  
  def fields
    field :id, as: :id
    field :name, as: :text
    field :description, as: :textarea
    field :category, as: :text
    field :price, as: :number
    field :location, as: :text
    field :provider_name, as: :text
    field :provider_email, as: :text
    field :provider_phone, as: :text
  end
end
