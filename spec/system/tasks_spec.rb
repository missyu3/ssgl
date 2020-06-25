require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  wait = Selenium::WebDriver::Wait.new(:timeout => 100) 
  describe "タスク機能" do
    before do
      @user = FactoryBot.create(:user, email: "testTaskSystem@example.com")
      @team = FactoryBot.create(:team, name: "My Team", user_id: @user.id)
      @assign = FactoryBot.create(:assign, user_id: @user.id, team_id: @team.id)
      visit new_user_session_path
      fill_in "user_email", with: "testTaskSystem@example.com"
      fill_in "user_password", with: "testtest"
      click_button "サインイン"
    end

    example "タスクが登録できること" do
      visit new_team_assign_task_path(team_id: @team.id, assign_id: @assign.id)
      fill_in "task_title", with: "test Title"
      attach_file 'task_image', "#{Rails.root}/app/assets/images/tasks/1.png"  
      fill_in "task_content", with: "test Content"
      click_button "登録"
      wait.until{ expect(page).to have_content "test Title"}
    end

    example "タスクが編集できること", :retry => 3 do
      visit new_team_assign_task_path(team_id: @team.id, assign_id: @assign.id)
      fill_in "task_title", with: "test Title"
      attach_file 'task_image', "#{Rails.root}/app/assets/images/tasks/1.png"  
      fill_in "task_content", with: "test Content"
      click_button "登録"

      visit edit_team_assign_task_path(team_id: @team.id, assign_id: @assign.id, id: @assign.tasks.first)
      fill_in "task_title", with: "test Title Upate"
      attach_file 'task_image', "#{Rails.root}/app/assets/images/tasks/1.png"  
      fill_in "task_content", with: "test Content Update"
      click_button "登録"
      wait.until{ expect(page).to have_content "test Title Upate"}
    end

    example "タスクが削除できること", :retry => 3 do
      visit new_team_assign_task_path(team_id: @team.id, assign_id: @assign.id)
      fill_in "task_title", with: "test Title"
      attach_file 'task_image', "#{Rails.root}/app/assets/images/tasks/1.png"  
      fill_in "task_content", with: "test Content"
      click_button "登録"

      visit team_assign_task_path(team_id: @team.id, assign_id: @assign.id, id: @assign.tasks.first)
      click_link "課題削除"
      page.driver.browser.switch_to.alert.accept
      wait.until{ expect(page).to have_content "削除しました"}
    end

    example "タスクに取り組むことができること", :retry => 3 do
      visit new_team_assign_task_path(team_id: @team.id, assign_id: @assign.id)
      fill_in "task_title", with: "test Title"
      attach_file 'task_image', "#{Rails.root}/app/assets/images/tasks/1.png"  
      fill_in "task_content", with: "test Content"
      click_button "登録"
      visit team_assign_task_path(team_id: @team.id, assign_id: @assign.id, id: @assign.tasks.first)
      click_link "取り組む"
      wait.until{ expect(page).to have_content "こちらの課題に取り組みました"}
    end

    example "タスクを諦めることができること", :retry => 3 do
      visit new_team_assign_task_path(team_id: @team.id, assign_id: @assign.id)
      fill_in "task_title", with: "test Title"
      attach_file 'task_image', "#{Rails.root}/app/assets/images/tasks/1.png"  
      fill_in "task_content", with: "test Content"
      click_button "登録"
      visit team_assign_task_path(team_id: @team.id, assign_id: @assign.id, id: @assign.tasks.first)
      click_link "取り組む"
      click_link "諦める"
      page.driver.browser.switch_to.alert.accept
      wait.until{ expect(page).to have_content "こちらの課題を取り消しました"}
    end

    example "タスクの検索ができること", :retry => 3 do
      visit new_team_assign_task_path(team_id: @team.id, assign_id: @assign.id)
      fill_in "task_title", with: "test Title"
      attach_file 'task_image', "#{Rails.root}/app/assets/images/tasks/1.png"  
      fill_in "task_content", with: "test Content"
      click_button "登録"
      visit team_assign_task_path(team_id: @team.id, assign_id: @assign.id, id: @assign.tasks.first)
      click_link "取り組む"
      click_button "検索"
      wait.until{ expect(page).to have_content "テストユーザー"}
    end

    example "名前でのタスクの絞り込み検索ができること(成功)", :retry => 3 do
      visit new_team_assign_task_path(team_id: @team.id, assign_id: @assign.id)
      fill_in "task_title", with: "test Title"
      attach_file 'task_image', "#{Rails.root}/app/assets/images/tasks/1.png"  
      fill_in "task_content", with: "test Content"
      click_button "登録"
      visit team_assign_task_path(team_id: @team.id, assign_id: @assign.id, id: @assign.tasks.first)
      click_link "取り組む"
      fill_in "search_name", with: "テスト"
      click_button "検索"
      wait.until{ expect(page).to have_content "テストユーザー"}
    end

    example "名前でのタスクの絞り込み検索ができること(失敗)", :retry => 3 do
      visit new_team_assign_task_path(team_id: @team.id, assign_id: @assign.id)
      fill_in "task_title", with: "test Title"
      attach_file 'task_image', "#{Rails.root}/app/assets/images/tasks/1.png"  
      fill_in "task_content", with: "test Content"
      click_button "登録"
      visit team_assign_task_path(team_id: @team.id, assign_id: @assign.id, id: @assign.tasks.first)
      click_link "取り組む"
      fill_in "search_name", with: "hoge"
      click_button "検索"
      wait.until{ expect(page).not_to have_content "テストユーザー"}
    end

    example "ステータスでのタスクの絞り込み検索ができること(成功)", :retry => 3 do
      visit new_team_assign_task_path(team_id: @team.id, assign_id: @assign.id)
      fill_in "task_title", with: "test Title"
      attach_file 'task_image', "#{Rails.root}/app/assets/images/tasks/1.png"  
      fill_in "task_content", with: "test Content"
      click_button "登録"
      visit team_assign_task_path(team_id: @team.id, assign_id: @assign.id, id: @assign.tasks.first)
      click_link "取り組む"
      select "着手中", from: "number"
      click_button "検索"
      wait.until{ expect(page).to have_content "テストユーザー"}
    end

    example "ステータスでのタスクの絞り込み検索ができること(失敗)", :retry => 3 do
      visit new_team_assign_task_path(team_id: @team.id, assign_id: @assign.id)
      fill_in "task_title", with: "test Title"
      attach_file 'task_image', "#{Rails.root}/app/assets/images/tasks/1.png"  
      fill_in "task_content", with: "test Content"
      click_button "登録"
      visit team_assign_task_path(team_id: @team.id, assign_id: @assign.id, id: @assign.tasks.first)
      click_link "取り組む"
      select "完了", from: "number"
      click_button "検索"
      wait.until{ expect(page).not_to have_content "テストユーザー"}
    end
  end
end