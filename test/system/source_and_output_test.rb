require "application_system_test_case"

class SourceAndOutputTest < ApplicationSystemTestCase
  setup do
    login_with(FactoryBot.build(:user))
    @daemon = stub_daemon
  end

  test "config is blank" do
    @daemon.agent.config_write("")
    visit(source_and_output_daemon_setting_path)

    page.has_content?(I18n.t("fluentd.settings.source_and_output.setting_empty"))
    page.has_css?(".input .empty")
    page.has_css?(".output .empty")
  end

  sub_test_case "config is given" do
    setup do
      config = <<-CONFIG.strip_heredoc
        <source>
          # http://docs.fluentd.org/articles/in_forward
          type forward
          port 24224
        </source>

        <match debug.*>
          # http://docs.fluentd.org/articles/out_stdout
          type stdout
        </match>

        <match s3.*>
          type s3
          aws_key_id fofoaiofa
          aws_sec_key aaaaaaaaaaaaaae
          s3_bucket test
          s3_endpoint s3-us-west-1.amazonaws.com
          format out_file
          include_time_key false
          add_newline false
          output_tag true
          output_time true
          store_as gzip
          use_ssl true
          buffer_type memory
        </match>
      CONFIG
      @daemon.agent.config_write(config)
      visit(source_and_output_daemon_setting_path)
    end

    test "elements" do
      within(".input .card") do
        assert do
          !has_content?(I18n.t("fluentd.settings.source_and_output.setting_empty"))
        end
      end
      assert do
        has_css?(".input .card .card-header")
      end
      assert do
        has_css?(".output .card .card-header")
      end
      within(".filter .empty") do
        assert do
          has_content?(I18n.t("fluentd.settings.source_and_output.setting_empty"))
        end
      end
    end

    test ".card-body is hidden by default and click .card-header for display"  do
      assert do
        !page.has_css?('.input .card .card-body')
      end
      assert do
        !page.has_css?('.output .card .card-body')
      end
      all(".input .card .card-header").first.click
      assert do
        page.has_css?('.input .card .card-body')
      end
      all(".output .card .card-header").first.click
      assert do
        page.has_css?('.output .card .card-body')
      end
    end

    test "display plugin name" do
      assert_equal(first(".input .card .card-header").text, "forward")
      assert_equal(all(".output .card .card-header").map(&:text),
                   ["stdout (debug.*)", "s3 (s3.*)"])
    end

    sub_test_case "edit, update, delete" do
      setup do
        @config = <<-CONFIG.strip_heredoc
          <source>
            type forward
            port 24224
          </source>
        CONFIG
        @new_config = <<-CONFIG.strip_heredoc
          <source>
            @type http
            port 8899
          </source>
        CONFIG
        @daemon.agent.config_write(@config)
        visit(source_and_output_daemon_setting_path)
        all(".input .card .card-header").first.click
      end

      test "click edit button transform textarea, then click cancel button to reset" do
        assert do
          !page.has_css?(".input textarea")
        end
        find(".btn", text: I18n.t("terms.edit")).click
        original_contents = page.evaluate_script(<<-JS)
          document.querySelector(".CodeMirror").CodeMirror.getValue()
        JS
        assert_equal(@config, original_contents)
        page.execute_script(<<-JS)
          var cm = document.querySelector('.CodeMirror').CodeMirror;
          cm.setValue(#{@new_config.to_json});
        JS
        find(".btn", text: I18n.t("terms.cancel")).click
        contents = page.evaluate_script("document.querySelector('.input pre').textContent")
        assert_equal(@config, contents)
        assert_equal(@daemon.agent.config.strip, @config.strip)
      end

      test "click edit button transform textarea, then click update button to be stored" do
        assert do
          !page.has_css?(".input textarea")
        end
        find(".btn", text: I18n.t("terms.edit")).click
        original_contents = page.evaluate_script(<<-JS)
          document.querySelector(".CodeMirror").CodeMirror.getValue()
        JS
        assert_equal(@config, original_contents)
        page.execute_script(<<-JS)
          var cm = document.querySelector('.CodeMirror').CodeMirror;
          cm.setValue(#{@new_config.to_json});
        JS
        find(".btn", text: I18n.t("terms.save")).click
        contents = page.evaluate_script("document.querySelector('.input pre').textContent")
        pend("contents does not include all lines under '.input pre'")
        assert_equal(@new_config, contents)
        assert_equal(@daemon.agent.config.strip, @new_config.strip)
      end

      test "click delete button transform textarea" do
        assert do
          page.has_css?(".input .card-body")
        end
        button = find(".btn", text: I18n.t('terms.destroy'))
        page.accept_confirm do
          button.click
        end
        assert do
          !page.has_css?(".input .card-body")
        end
        assert_equal("", @daemon.agent.config.strip)
      end

      test "click delete button then cancel it" do
        assert do
          page.has_css?(".input .card-body")
        end
        page.dismiss_confirm("really?") do
          find(".btn", text: I18n.t('terms.destroy')).click
        end
        assert do
          page.has_css?(".input .card-body")
        end
        assert_equal(@config.strip, @daemon.agent.config.strip)
      end
    end
  end

  sub_test_case "filter" do
    setup do
      config = <<-CONFIG.strip_heredoc
        <source>
           @type dummy
           tag debug.*
        </source>

        <filter debug.*>
          @type stdout
        </filter>

        <match debug.*>
          # http://docs.fluentd.org/articles/out_stdout
          type stdout
        </match>
      CONFIG
      @daemon.agent.config_write(config)
      visit(source_and_output_daemon_setting_path)
    end

    test "elements" do
      assert_equal(first(".filter .card .card-header").text, "stdout (debug.*)")
    end
  end

  sub_test_case "label" do
    setup do
      @config = <<-CONFIG.strip_heredoc
        <source>
           @type dummy
           tag debug.*
           @label @INPUT
        </source>

        <label @INPUT>
          <filter debug.*>
            @type grep
            <regexp>
              key message
              pattern /debug.+/
            </regexp>
          </filter>

          <match debug.*>
            @type stdout
          </match>
        </label>
      CONFIG
      @daemon.agent.config_write(@config)
      visit(source_and_output_daemon_setting_path)
    end

    test "elements under @INPUT" do
      assert do
        all(".input h5").map(&:text).include?("@INPUT")
      end
      assert_equal(first(".input .card .card-header").text, "dummy")
      assert do
        all(".filter h5").map(&:text).include?("@INPUT")
      end
      assert_equal(first(".filter .card .card-header").text, "grep (debug.*)")
      assert do
        all(".output h5").map(&:text).include?("@INPUT")
      end
      assert_equal(first(".output .card .card-header").text, "stdout (debug.*)")
    end

    test "click delete button" do
      assert do
        find(".filter .card-header").click
      end
      page.accept_confirm do
        find(".filter .btn", text: I18n.t("terms.destroy")).click
      end
      within(".filter .empty") do
        assert do
          has_content?(I18n.t("fluentd.settings.source_and_output.setting_empty"))
        end
      end
    end

    test "click edit and cancel" do
      config = <<-CONFIG.strip_heredoc
        <filter debug.*>
          @type grep
          <regexp>
            key message
            pattern /debug.+/
          </regexp>
        </filter>
      CONFIG
      new_config = <<-CONFIG.strip_heredoc
        <filter debug.*>
          @type grep
          <regexp>
            key message
            pattern /debug2.+/
          </regexp>
        </filter>
      CONFIG
      assert do
        find(".filter .card-header").click
      end
      find(".filter .btn", text: I18n.t("terms.edit")).click
      original_contents = page.evaluate_script(%Q!document.querySelector(".CodeMirror").CodeMirror.getValue()!)
      assert_equal(original_contents, config)
      page.execute_script(<<-JS)
        var cm = document.querySelector('.CodeMirror').CodeMirror;
        cm.setValue(#{new_config.to_json});
      JS
      find(".filter .btn", text: I18n.t("terms.cancel")).click
      contents = page.evaluate_script("document.querySelector('.filter pre').textContent")
      assert_equal(contents, config)
      assert_equal(@daemon.agent.config.strip, @config.strip)
    end

    test "click edit and save" do
      config = <<-CONFIG.strip_heredoc
        <filter debug.*>
          @type grep
          <regexp>
            key message
            pattern /debug.+/
          </regexp>
        </filter>
      CONFIG
      new_config = <<-CONFIG.strip_heredoc
        <filter debug.*>
          @type grep
          <regexp>
            key message
            pattern /debug2.+/
          </regexp>
        </filter>
      CONFIG
      assert do
        find(".filter .card-header").click
      end
      find(".filter .btn", text: I18n.t("terms.edit")).click
      original_contents = page.evaluate_script(%Q!document.querySelector(".CodeMirror").CodeMirror.getValue()!)
      assert_equal(original_contents, config)
      page.execute_script(<<-JS)
        var cm = document.querySelector('.CodeMirror').CodeMirror;
        cm.setValue(#{new_config.to_json});
      JS
      find(".filter .btn", text: I18n.t("terms.save")).click
      sleep(1)
      contents = page.evaluate_script("document.querySelector('.filter pre').textContent")
      assert_equal(new_config, contents)
    end
  end
end
