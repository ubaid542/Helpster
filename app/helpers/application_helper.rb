module ApplicationHelper


    def status_badge_color(status)
  case status
  when 'pending'
    'bg-yellow-100 text-yellow-800'
  when 'confirmed'
    'bg-green-100 text-green-800'
  when 'cancelled'
    'bg-red-100 text-red-800'
  when 'completed'
    'bg-blue-100 text-blue-800'
  else
    'bg-gray-100 text-gray-800'
  end
end

def status_border_color(status)
  case status
  when 'pending'
    'border-yellow-400'
  when 'confirmed'
    'border-green-400'
  when 'cancelled'
    'border-red-400'
  when 'completed'
    'border-blue-400'
  else
    'border-gray-400'
  end
end
  
end