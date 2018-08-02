/* global _ */
"use strict";

import "lodash/lodash";

$(document).ready(() => {
  const SettingSection = {
    template: "#vue-setting-section",
    props: ["initialId", "initialContent", "initialType", "initialName", "initialArg"],
    data: function() {
      return {
        mode: "default",
        processing: false,
        id: null,
        content: null,
        type: null,
        name: null,
        arg: null
      };
    },
    created: function() {
      this.initialState();
      this.id = this.initialId;
      this.content = this.initialContent;
      this.type = this.initialType;
      this.name = this.initialName;
      this.arg = this.initialArg;
    },
    computed: {
      endpoint: function() {
        return "/api/settings/" + this.id;
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
            id: this.id
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
          sources: [],
          matches: []
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
        $.getJSON("/api/settings", (data)=> {
          var sources = [];
          var matches = [];
          data.forEach((v)=> {
            if(v.name === "source"){
              sources.push(v);
            }else{
              matches.push(v);
            }
          });
          this.sections.sources = sources;
          this.sections.matches = matches;
          this.loaded = true;
          setTimeout(()=> {
            this.loading = false;
          }, 500);
        });
      }
    }
  });
});
