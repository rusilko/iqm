module EventsHelper
  def link_to_add_participant_row_old(name, f, association) 
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.simple_fields_for(association, new_object, child_index: id) do |builder|
      # new_participant = Participant.new
      # builder.simple_fields_for :participant, new_participant, defaults: { 
      #                                         label: false, 
      #                                         wrapper_html: { class: '' }, 
      #                                         input_html: { class:'' }
      #                                       } do |participant_builder|
        render 'participant_fields', f: builder, i: raw("<i class=\"icon-star new_row_star\"></i>"), aev: f.object.id, new_obj: true
      # end
    end
    link_to(name, '#', class: "btn btn-success add_participant_btn", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def setup_event(event)
    unless event.errors.any?
      2.times { event.event_participations.build.build_participant }
    end
    event
  end

end
