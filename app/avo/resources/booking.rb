class Avo::Resources::Booking < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }
  
  def fields
    field :id, as: :id
    field :client, as: :belongs_to
    field :service_provider, as: :belongs_to
    field :service, as: :belongs_to
    field :date, as: :date
    field :time, as: :text
    field :status, as: :text
    field :price, as: :number
  end
end
