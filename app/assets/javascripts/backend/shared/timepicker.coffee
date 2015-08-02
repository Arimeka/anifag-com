if $('#datetimepicker').length > 0
  $('#datetimepicker').datetimepicker({
    format:           'YYYY-MM-DDTHH:mm:ssZZ',
    locale:           moment().locale(),
    showTodayButton:  true,
    showClear:        true,
    icons:            {
                        time: 'fa fa-clock-o',
                        date: 'fa fa-calendar',
                        up: 'fa fa-chevron-up',
                        down: 'fa fa-chevron-down',
                        previous: 'fa fa-chevron-left',
                        next: 'fa fa-chevron-right',
                        today: 'fa fa-home',
                        clear: 'fa fa-trash-o',
                      }
  })
