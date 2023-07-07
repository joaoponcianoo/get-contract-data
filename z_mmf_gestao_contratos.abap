FUNCTION z_mmf_gestao_contratos .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(I_EBELN) TYPE  ZMT_CONTRATO_REQ
*"  EXPORTING
*"     REFERENCE(E_DATA) TYPE  ZMT_CONTRATO_RES
*"  EXCEPTIONS
*"      NOT_FOUND
*"----------------------------------------------------------------------

*-----------------------------------------------------------------------
*                          >>> QINTESS <<<
* Cliente:        Celesc
* Descrição:      Informações para Gestão de Contrato
* Consultor ABAP: João Guilherme Ponciano
* Data:           04/07/2023
* Request:        ECDK965803
*-----------------------------------------------------------------------

  TYPES:
    BEGIN OF ty_ekko,
      ebeln       TYPE ekko-ebeln,
      bukrs       TYPE ekko-bukrs,
      bsart       TYPE ekko-bsart,
      ekgrp       TYPE ekko-ekgrp,
      ekorg       TYPE ekko-ekorg,
      lifnr       TYPE ekko-lifnr,
      bedat       TYPE ekko-bedat,
      kdatb       TYPE ekko-kdatb,
      kdate       TYPE ekko-kdate,
      zterm       TYPE ekko-zterm,
      ktwrt       TYPE ekko-ktwrt,
      waers       TYPE ekko-waers,
      idlic       TYPE ekko-idlic,
      idmod       TYPE ekko-idmod,
      nproc       TYPE ekko-nproc,
      zdiretor    TYPE ekko-zdiretor,
      zpernr      TYPE ekko-zpernr,
      zfiscal_adm TYPE ekko-zfiscal_adm,
      zfiscal_tec TYPE ekko-zfiscal_tec,
    END OF ty_ekko,

    BEGIN OF ty_lfa1,
      name1     TYPE lfa1-name1,
      adrnr     TYPE lfa1-adrnr,
      spras     TYPE lfa1-spras,
      telf1     TYPE lfa1-telf1,
      telf2     TYPE lfa1-telf2,
      telfx     TYPE lfa1-telfx,
      stcd1     TYPE lfa1-stcd1,
      stcd2     TYPE lfa1-stcd2,
      stcd3     TYPE lfa1-stcd3,
      stcd4     TYPE lfa1-stcd4,
      txjcd     TYPE lfa1-txjcd,
      j_1kftbus TYPE lfa1-j_1kftbus,
      j_1kftind TYPE lfa1-j_1kftind,
    END OF ty_lfa1,

    BEGIN OF ty_adrc,
      street     TYPE adrc-street,
      house_num1 TYPE adrc-house_num1,
      city2      TYPE adrc-city2,
      post_code1 TYPE adrc-post_code1,
      city1      TYPE adrc-city1,
      country    TYPE adrc-country,
      region     TYPE adrc-region,
      taxjurcode TYPE adrc-taxjurcode,
    END OF ty_adrc,

    BEGIN OF ty_adr6,
      smtp_addr TYPE adr6-smtp_addr,
    END OF ty_adr6,

    BEGIN OF ty_adrct,
      remark TYPE adrct-remark,
    END OF ty_adrct,

    BEGIN OF ty_lfbk,
      banks TYPE lfbk-banks,
      bankl TYPE lfbk-bankl,
      bankn TYPE lfbk-bankn,
      koinh TYPE lfbk-koinh,
      bkont TYPE lfbk-bkont,
    END OF ty_lfbk,

    BEGIN OF ty_bnka,
      bankl TYPE bnka-bankl,
      banka TYPE bnka-banka,
    END OF ty_bnka,

    BEGIN OF ty_zmmt006,
      idresp TYPE zmmt006-idresp,
    END OF ty_zmmt006,

    BEGIN OF ty_zmmt012,
      enqlc        TYPE zmmt012-enqlc,
      objeto       TYPE string,
      mod_disp     TYPE zmmt012-mod_disp,
      inv_fases    TYPE zmmt012-inv_fases,
      reg_exe      TYPE zmmt012-reg_exe,
      tp_lic       TYPE zmmt012-tp_lic,
      obr_serv_eng TYPE zmmt012-obr_serv_eng,
    END OF ty_zmmt012,

    BEGIN OF ty_zmmt025,
      dtlan TYPE zmmt025-dtlan,
      dtlpu TYPE zmmt025-dtlpu,
      respj TYPE zmmt025-respj,
      dtapj TYPE zmmt025-dtapj,
      vlacp TYPE zmmt025-vlacp,
      dtvac TYPE zmmt025-dtvac,
      dtabe TYPE zmmt025-dtabe,
    END OF ty_zmmt025,

    BEGIN OF ty_zmmt122,
      idrisco TYPE zmmt122-idrisco,
    END OF ty_zmmt122.

  DATA:
    BEGIN OF tline OCCURS 100.
      INCLUDE STRUCTURE tline.
    DATA: END OF tline.

  DATA:
    ls_ekko        TYPE ty_ekko,
    ls_lfa1        TYPE ty_lfa1,
    ls_adrc        TYPE ty_adrc,
    ls_adr6        TYPE ty_adr6,
    ls_adrct       TYPE ty_adrct,
    ls_lfbk        TYPE ty_lfbk,
    ls_bnka        TYPE ty_bnka,
    ls_zmmt006     TYPE ty_zmmt006,
    ls_zmmt012     TYPE ty_zmmt012,
    ls_zmmt025     TYPE ty_zmmt025,
    ls_zmmt122     TYPE ty_zmmt122,

    ls_lines       TYPE tline,
    ls_thead       TYPE thead,

    ls_email       TYPE zdt_contrato_res_lista_de_emai,
    ls_dados_banco TYPE zdt_contrato_res_dados_de_banc.

  DATA:
    lt_adr6  TYPE TABLE OF ty_adr6,
    lt_lfbk  TYPE TABLE OF ty_lfbk,
    lt_bnka  TYPE TABLE OF ty_bnka,
    lt_lines TYPE TABLE OF tline.

  DATA:
    lv_ebeln TYPE ebeln.

  lv_ebeln = i_ebeln-mt_contrato_req-contrato.

  SELECT SINGLE ebeln bukrs bsart ekgrp ekorg lifnr bedat
                kdatb kdate zterm ktwrt waers idlic idmod
                nproc zdiretor zpernr zfiscal_adm zfiscal_tec
    FROM ekko
    INTO ls_ekko
   WHERE ebeln EQ lv_ebeln.

  IF sy-subrc EQ 0.

    SELECT SINGLE name1 adrnr spras telf1 telf2 telfx stcd1
                  stcd2 stcd3 stcd4 txjcd j_1kftbus j_1kftind
      FROM lfa1
      INTO ls_lfa1
     WHERE lifnr EQ ls_ekko-lifnr.

    IF sy-subrc EQ 0.
      IF ls_lfa1-adrnr IS NOT INITIAL.

        SELECT SINGLE street house_num1 city2 post_code1
                      city1 country region taxjurcode
          FROM adrc
          INTO ls_adrc
         WHERE addrnumber EQ ls_lfa1-adrnr.

        SELECT smtp_addr
          FROM adr6
          INTO TABLE lt_adr6
         WHERE addrnumber EQ ls_lfa1-adrnr.

        SELECT SINGLE remark
          FROM adrct
          INTO ls_adrct
         WHERE addrnumber EQ ls_lfa1-adrnr
           AND langu      EQ 'P'.

      ENDIF.
    ENDIF.

    SELECT banks bankl bankn koinh bkont
      FROM lfbk
      INTO TABLE lt_lfbk
     WHERE lifnr EQ ls_ekko-lifnr.

    IF sy-subrc EQ 0.

      SELECT bankl banka
        FROM bnka
        INTO TABLE lt_bnka
     FOR ALL ENTRIES IN lt_lfbk
       WHERE bankl EQ lt_lfbk-bankl.

      SORT lt_bnka BY bankl.

    ENDIF.

    SELECT SINGLE idresp
      FROM zmmt006
      INTO ls_zmmt006
     WHERE idlic EQ ls_ekko-idlic
       AND endda EQ '99991231'.

    SELECT SINGLE enqlc idtxt_grupoaf mod_disp
                  inv_fases reg_exe tp_lic obr_serv_eng
      FROM zmmt012
      INTO ls_zmmt012
     WHERE idlco EQ ls_ekko-idlic.

    IF sy-subrc EQ 0.

      ls_thead-tdid     = 'Z004'.
      ls_thead-tdspras  = 'P'.
      ls_thead-tdname   = ls_zmmt012-objeto.
      ls_thead-tdobject = 'ZLICIT'.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = ls_thead-tdid
          language                = ls_thead-tdspras
          name                    = ls_thead-tdname
          object                  = ls_thead-tdobject
          archive_handle          = 0
        TABLES
          lines                   = lt_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.

      IF sy-subrc EQ 0.

        READ TABLE lt_lines INTO ls_lines INDEX 1.
        IF ls_lines-tdline IS NOT INITIAL.
          ls_zmmt012-objeto = ls_lines-tdline.
        ELSE.
          CLEAR ls_zmmt012-objeto.
        ENDIF.

      ENDIF.
    ENDIF.

    SELECT SINGLE dtlan dtlpu respj dtapj vlacp dtvac dtabe
      FROM zmmt025
      INTO ls_zmmt025
     WHERE idlic EQ ls_ekko-idlic.

    SELECT SINGLE idrisco
      FROM zmmt122
      INTO ls_zmmt122
     WHERE idlic   EQ ls_ekko-idlic
       AND idrisco NE space.

    e_data-mt_contrato_res-contrato               = ls_ekko-ebeln.
    e_data-mt_contrato_res-empresa                = ls_ekko-bukrs.
    e_data-mt_contrato_res-tipo_de_documento      = ls_ekko-bsart.
    e_data-mt_contrato_res-grupo_de_compradores   = ls_ekko-ekgrp.
    e_data-mt_contrato_res-organizacao_de_compras = ls_ekko-ekorg.
    e_data-mt_contrato_res-fornecedor             = ls_ekko-lifnr.
    e_data-mt_contrato_res-data_do_contrato       = ls_ekko-bedat.
    e_data-mt_contrato_res-inic_periodo_validade  = ls_ekko-kdatb.
    e_data-mt_contrato_res-fim_validade           = ls_ekko-kdate.
    e_data-mt_contrato_res-condicao_pgto          = ls_ekko-zterm.
    e_data-mt_contrato_res-valor_fixado           = ls_ekko-ktwrt.
    e_data-mt_contrato_res-codigo_moeda           = ls_ekko-waers.
    e_data-mt_contrato_res-n_licitacao            = ls_ekko-idlic.
    e_data-mt_contrato_res-modalidade             = ls_ekko-idmod.
    e_data-mt_contrato_res-processo               = ls_ekko-nproc.
    e_data-mt_contrato_res-diretor_do_contrato    = ls_ekko-zdiretor.
    e_data-mt_contrato_res-gestor_do_contrato     = ls_ekko-zpernr.
    e_data-mt_contrato_res-fical_adm              = ls_ekko-zfiscal_adm.
    e_data-mt_contrato_res-fical_tecnico          = ls_ekko-zfiscal_tec.

    e_data-mt_contrato_res-nome                   = ls_lfa1-name1.

    e_data-mt_contrato_res-rua                    = ls_adrc-street.
    e_data-mt_contrato_res-numero                 = ls_adrc-house_num1.
    e_data-mt_contrato_res-bairro                 = ls_adrc-city2.
    e_data-mt_contrato_res-cep                    = ls_adrc-post_code1.
    e_data-mt_contrato_res-cidade                 = ls_adrc-city1.
    e_data-mt_contrato_res-pais                   = ls_adrc-country.
    e_data-mt_contrato_res-regiao                 = ls_adrc-region.
    e_data-mt_contrato_res-domicilio_fiscal       = ls_adrc-taxjurcode.

    e_data-mt_contrato_res-idioma                 = ls_lfa1-spras.
    e_data-mt_contrato_res-telefone               = ls_lfa1-telf1.
    e_data-mt_contrato_res-celular                = ls_lfa1-telf2.
    e_data-mt_contrato_res-fax                    = ls_lfa1-telfx.

    e_data-mt_contrato_res-observacoes            = ls_adrct-remark.

    e_data-mt_contrato_res-cnpj                   = ls_lfa1-stcd1.
    e_data-mt_contrato_res-cpf                    = ls_lfa1-stcd2.
    e_data-mt_contrato_res-insc_estadual          = ls_lfa1-stcd3.
    e_data-mt_contrato_res-insc_municipal         = ls_lfa1-stcd4.
    e_data-mt_contrato_res-situacao_fornecedor    = ls_lfa1-j_1kftbus.
    e_data-mt_contrato_res-regime_da_empresa      = ls_lfa1-j_1kftind.

    LOOP AT lt_adr6 INTO ls_adr6.
      ls_email-e_mail = ls_adr6-smtp_addr.
      APPEND ls_email TO e_data-mt_contrato_res-lista_de_emails.
      CLEAR ls_email.
    ENDLOOP.

    LOOP AT lt_lfbk INTO ls_lfbk.
      ls_dados_banco-pais               = ls_lfbk-banks.
      ls_dados_banco-chave_do_banco     = ls_lfbk-bankl.
      ls_dados_banco-conta_bancaria     = ls_lfbk-bankn.
      ls_dados_banco-titular_conta      = ls_lfbk-koinh.
      ls_dados_banco-chave_controle_bco = ls_lfbk-bkont.

      READ TABLE lt_bnka INTO ls_bnka WITH KEY bankl = ls_lfbk-bankl BINARY SEARCH.
      IF sy-subrc EQ 0.
        ls_dados_banco-nome_inst_financeira = ls_bnka-banka.
      ENDIF.

      APPEND ls_dados_banco TO e_data-mt_contrato_res-dados_de_banco.
      CLEAR ls_dados_banco.
    ENDLOOP.

    e_data-mt_contrato_res-responsavel                = ls_zmmt006-idresp.

    e_data-mt_contrato_res-enquadramento              = ls_zmmt012-enqlc.
    e_data-mt_contrato_res-objeto                     = ls_zmmt012-objeto.
    e_data-mt_contrato_res-modo_disputa               = ls_zmmt012-mod_disp.
    e_data-mt_contrato_res-inversao_fases             = ls_zmmt012-inv_fases.
    e_data-mt_contrato_res-regime_execucao            = ls_zmmt012-reg_exe.
    e_data-mt_contrato_res-tipo_licitacao             = ls_zmmt012-tp_lic.
    e_data-mt_contrato_res-obra_serv_eng              = ls_zmmt012-obr_serv_eng.

    e_data-mt_contrato_res-data_lancamento            = ls_zmmt025-dtlan.
    e_data-mt_contrato_res-data_limite_publicidade    = ls_zmmt025-dtlpu.
    e_data-mt_contrato_res-responsavel_aprov_juridica = ls_zmmt025-respj.
    e_data-mt_contrato_res-data_aprov_juridica        = ls_zmmt025-dtapj.
    e_data-mt_contrato_res-dias_de_validade           = ls_zmmt025-vlacp.
    e_data-mt_contrato_res-data_validade              = ls_zmmt025-dtvac.
    e_data-mt_contrato_res-data_abertura              = ls_zmmt025-dtabe.

    e_data-mt_contrato_res-nivel_de_risco             = ls_zmmt122-idrisco.

  ELSE.
    e_data-mt_contrato_res-contrato = lv_ebeln.
    e_data-mt_contrato_res-msg_erro = 'Não encontrado informações para o contrato informado.'.
    RAISE not_found.
  ENDIF.

ENDFUNCTION.
