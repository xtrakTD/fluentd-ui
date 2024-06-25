/* global _ */
"use strict";

import "lodash/lodash";

window.addEventListener("load", () => {
  const SettingSection = {
    template: "#vue-setting-section",
    props: [
      "initialLabel",
      "initialId",
      "initialContent",
      "initialType",
      "initialName",
      "initialArg"
    ],
    data: function() {
      return {
        mode: "default",
        processing: false,
        current_label: null,
        id: null,
        content: null,
        type: null,
        name: null,
        arg: null
      };
    },
    created: function() {
      this.initialState();
      this.current_label = this.initialLabel;
      this.id = this.initialId;
      this.content = this.initialContent;
      this.type = this.initialType;
      this.name = this.initialName;
      this.arg = this.initialArg;
    },
    computed: {
      endpoint: function() {
        return `${relativeUrlRoot}/api/settings/${this.id}`;
      },
      token: function() {
        return Rails.csrfToken();
      }
    },
    methods: {
      onCancel: function(_event) {
        this.initialState();
      },
      onEdit: function(_event) {
        this.mode = "edit";
      },
      onDelete: function(_event) {
        if (!confirm("really?")) {
          return;
        }
        this.destroy();
      },
      onSubmit: function(_event) {
        this.processing = true;
        this.content = $(`#${this.id} textarea.form-control`)[0].dataset.content;
        $.ajax({
          url: this.endpoint,
          method: "POST",
          data: {
            _method: "PATCH",
            label: this.current_label,
            pluginType: this.name,
            id: this.id,
            content: this.content
          },
          headers: {
            "X-CSRF-Token": this.token
          }
        }).then((data)=> {
          _.each(data, (v, k) => {
            this[k] = v;
          });
          this.initialState();
        }).always(()=> {
          this.processing = false;
        });
      },
      initialState: function(){
        this.processing = false;
        this.mode = "default";
      },
      destroy: function(){
        $.ajax({
          url: this.endpoint,
          method: "POST",
          data: {
            _method: "DELETE",
            label: this.current_label,
            pluginType: this.name,
            arg: this.arg,
            id: this.id,
          },
          headers: {
            "X-CSRF-Token": this.token
          }
        }).then(()=> {
          this.$parent.update();
        });
      }
    }
  };

  new Vue({
    el: "#vue-setting",
    components: {
      "setting-section": SettingSection
    },
    data: function(){
      return {
        loaded: false,
        loading: false,
        sections: {
          "ROOT": {
            sources: [],
            filters: [],
            matches: []
          }
        }
      };
    },
    mounted: function() {
      this.$nextTick(() => {
        this.update();
      });
    },
    methods: {
      update: function() {
        this.loading = true;
        $.getJSON(`${relativeUrlRoot}/api/settings`, (data) => {
          console.log(data);
          _.each(data, (elements, label) => {
            this.$set(this.sections, label, elements);
          });
          _.each(this.sections, (elements, label) => {
            if (_.isEmpty(data[label])) {
              this.$delete(this.sections, label);
            }
          });
          if (_.isEmpty(data["ROOT"])) {
            this.$set(this.sections, "ROOT", []);
          }
          this.loaded = true;
          setTimeout(() => {
            this.loading = false;
          }, 500);
        });
      }
    }
  });
});
