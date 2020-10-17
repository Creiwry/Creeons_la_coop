# frozen_string_literal: true

# rubocop: disable Metrics/BlockLength
ActiveAdmin.register Member do
  includes :groups
  permit_params :email,
                :password,
                :encrypted_password,
                :first_name,
                :last_name,
                :biography,
                :phone_number,
                :role,
                :moderator,
                :confirmed_at,
                :password_confirmation,
                :cash_register_proficiency,
                :register_id,
                group_ids: []

  index do
    selectable_column
    column :first_name
    column :last_name
    column :role
    column('3 heures faites?') { |member| member.worked_three_hours?(Date.current) }
    column(:group) { |member| member.groups.map(&:name).join(', ') }
    column :cash_register_proficiency
    column :register_id
    column :email
    actions
  end

  csv do
    column :email
    column :first_name
    column :last_name
    column :phone_number
    column :group
    column :role
    column("3 heures de #{l 1.month.ago, format: '%B'}?") { |member| member.worked_three_hours?(1.month.ago) }
    column("3 heures de #{l Date.current, format: '%B'}?") { |member| member.worked_three_hours?(Date.current) }
    column("3 heures de #{l 1.month.from_now, format: '%B'}?") { |member| member.worked_three_hours?(1.month.from_now) }
    column(:group) { |member| member.groups.map(&:name).join(', ') }
    column :cash_register_proficiency
    column :register_id
  end

  show do
    attributes_table_for resource do
      default_attribute_table_rows.each do |field|
        row field
      end
      table_for member.groups do
        column 'groups' do |group|
          link_to Arbre::Context.new { (status_tag class: 'important', label: group.name) }, [:admin, group]
        end
      end
    end
  end

  form do |f|
    f.inputs :first_name,
             :last_name,
             :email,
             :phone_number,
             :role,
             :moderator,
             :cash_register_proficiency,
             :register_id,
             :biography
    f.input :groups, as: :check_boxes
    actions
  end

  filter :email
  filter :first_name
  filter :last_name
  filter :email
  filter :role
  filter :group
  filter :cash_register_proficiency

  action_item :invite_member, only: :index do
    link_to t('active_admin.invite_member'), new_member_invitation_path
  end

  controller do
    def create(options = {}, &block)
      new_unloggable_member = build_resource
      first_name = new_unloggable_member.first_name
      last_name = new_unloggable_member.last_name
      new_unloggable_member.email = "#{first_name}.#{last_name}.#{Date.current}@compte.web.inactif"

      def new_unloggable_member.password_required?
        false
      end

      def new_unloggable_member.email_required?
        false
      end

      options[:location] ||= smart_resource_url if create_resource(new_unloggable_member)

      respond_with_dual_blocks(new_unloggable_member, options, &block)
    end
  end
end
# rubocop: enable Metrics/BlockLength
