METHOD zii_si_contrato_sync_in~si_contrato_sync_in.

    CALL FUNCTION 'Z_MMF_GESTAO_CONTRATOS'
      EXPORTING
        i_ebeln   = input
      IMPORTING
        e_data    = output
      EXCEPTIONS
        not_found = 1
        OTHERS    = 2.

ENDMETHOD.