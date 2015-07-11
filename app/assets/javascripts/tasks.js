function initialize() {
  available_locales = ['en', 'ru'];
  locale = $('input.datetimepicker').attr('locale');
  if(locale != 'en' && $.inArray(locale, available_locales) >= 0) {
    $('.datetimepicker').datetimepicker({locale: locale});
  } else {
    $('.datetimepicker').datetimepicker();
  }
}

$(document).ready(initialize);
$(document).on('page:load', initialize);