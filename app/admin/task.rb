ActiveAdmin.register Task do

  permit_params :repeat_count, :every_minutes, :every_hours, :every_days, :every_months,
  :every_years, :name, :description, :start_date, :user_id

  index do
    selectable_column
    id_column
    column :user
    column :name
    column :status do |task|
      status_tag task.status, task.performed? ? :ok : :none
    end
    column :start_date
    column :updated_at
    column :repeat_count
    column :repeating
    actions
  end


  show do
    panel I18n.t(:task_details) do
      attributes_table_for task do
        row :name
        row :description

        row :start_date

        row :status do |task|
          status_tag task.status, task.performed? ? :ok : :none
        end
        
        if task.repeatable? 
          row :repeat_count
          row :repeating
        end

        row :user

        row :updated_at
        row :created_at


      end
    end
    active_admin_comments
  end



  form do |f|
    columns do
      column do
        inputs I18n.t(:task_details), class: 'task_details' do
          input :name
          input :description
          input :start_date, as: :datetime_select, min: Time.now
          input :user
        end
      end
      column do
        inputs I18n.t('admin.tasks.repeating'), class: 'task_repeating_params' do
          input :repeat_count
          render partial: 'repeating_form', locals: {f: f}
        end
      end
    end

    actions
  end
end
