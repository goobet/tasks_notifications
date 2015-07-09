ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do

    columns do
      column do
        panel "Recent updated tasks" do
          ul do
            Task.order(updated_at: :desc).last(5).map do |task|
              li link_to(task.name, admin_task_path(task))
            end
          end
        end
      end

      column do
        panel "Recent registered users" do
          ul do
            User.order(created_at: :desc).last(5).map do |user|
              li link_to(user.name, admin_user_path(user))
            end
          end
        end
      end
    end
  end # content
end
