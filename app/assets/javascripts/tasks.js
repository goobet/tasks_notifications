function initialize() {
  available_locales = ['en', 'ru'];
  picker = $('.datetimepicker input');
  locale = picker.attr('locale');
  value = new Date(picker.attr('def_value'));

  if(locale != undefined && locale != 'en' && $.inArray(locale, available_locales) >= 0) {
    $('.datetimepicker').datetimepicker({
      locale: locale,
      defaultDate: value
    });
  } else {
    $('.datetimepicker').datetimepicker({
      defaultDate: value
    });
  }
}

$(document).ready(initialize);
$(document).on('page:load', initialize);