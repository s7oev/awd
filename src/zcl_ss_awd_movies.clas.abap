CLASS zcl_ss_awd_movies DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES:
      movies_tt TYPE TABLE OF zss_awd_movies WITH EMPTY KEY.

    CLASS-METHODS:
      create
        IMPORTING name          TYPE string
                  year          TYPE i
        RETURNING VALUE(result) TYPE sy-subrc,

      read_all
        RETURNING VALUE(result) TYPE movies_tt,

      itab_to_html_tab
        IMPORTING movies        TYPE zcl_ss_awd_movies=>movies_tt
        RETURNING VALUE(result) TYPE string.

ENDCLASS.



CLASS zcl_ss_awd_movies IMPLEMENTATION.
  METHOD create.
    DATA(movie) = VALUE zss_awd_movies( name = name year_ = year ).

    INSERT zss_awd_movies FROM @movie.

    result = sy-subrc.
  ENDMETHOD.


  METHOD read_all.
    SELECT *
      FROM zss_awd_movies
      INTO TABLE @result.
  ENDMETHOD.


  METHOD itab_to_html_tab.
    result = |<ul>|.

    LOOP AT movies REFERENCE INTO DATA(movie).
      result &&= |<li>{ movie->name } ({ movie->year_ })</li>|.
    ENDLOOP.

    result &&= |</ul>|.
  ENDMETHOD.
ENDCLASS.
