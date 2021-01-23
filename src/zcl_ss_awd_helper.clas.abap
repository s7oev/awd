CLASS zcl_ss_awd_helper DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES:
      BEGIN OF var_and_content_s,
        variable TYPE string,
        content  TYPE string,
      END OF var_and_content_s,

      var_and_content_tt TYPE TABLE OF var_and_content_s WITH EMPTY KEY.

    CLASS-METHODS:
      format_path
        IMPORTING path          TYPE string
        RETURNING VALUE(result) TYPE string,

      get_page_html
        IMPORTING page_name     TYPE string
        RETURNING VALUE(result) TYPE string,

      render_html
        IMPORTING html                TYPE string
                  var_and_content_tab TYPE var_and_content_tt
        RETURNING VALUE(result)       TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_ss_awd_helper IMPLEMENTATION.
  METHOD format_path.
    DATA(path_length) = strlen( path ) - 1.
    result = to_upper( path+1(path_length) ).
  ENDMETHOD.


  METHOD get_page_html.
    SELECT SINGLE content
      FROM zss_awd_html
      WHERE page_name = @page_name
      INTO @result.
  ENDMETHOD.


  METHOD render_html.
    result = html.

    LOOP AT var_and_content_tab REFERENCE INTO DATA(var_and_content).
      result = replace( val = result sub = |${ var_and_content->variable }| with = var_and_content->content ).
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
