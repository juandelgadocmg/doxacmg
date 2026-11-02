-- ====================================================
-- 1. COLUMNAS Y CAMPOS FALTANTES QUE PIDE EL FRONTEND
-- ====================================================
ALTER TABLE public.role_permissions ADD COLUMN IF NOT EXISTS action_key text;
ALTER TABLE public.pagos_matricula ADD COLUMN IF NOT EXISTS concepto_pago_id uuid;
ALTER TABLE public.inscripciones ADD COLUMN IF NOT EXISTS confirmado boolean DEFAULT false;
ALTER TABLE public.eventos ADD COLUMN IF NOT EXISTS sede text DEFAULT 'Principal';
ALTER TABLE public.personas ADD COLUMN IF NOT EXISTS sede text DEFAULT 'Principal';
ALTER TABLE public.personas ADD COLUMN IF NOT EXISTS correo text;
ALTER TABLE public.personas ADD COLUMN IF NOT EXISTS full_name text;
ALTER TABLE public.leaders ADD COLUMN IF NOT EXISTS telefono text;
UPDATE public.personas SET correo = email WHERE correo IS NULL AND email IS NOT NULL;
UPDATE public.personas SET full_name = trim(concat(nombres, ' ', coalesce(apellidos, ''))) WHERE full_name IS NULL;
UPDATE public.leaders SET telefono = phone WHERE telefono IS NULL AND phone IS NOT NULL;

-- ====================================================
-- 2. LLAVES FOR�NEAS (RELACIONES ENTRE TABLAS)
-- ====================================================
DO $$ BEGIN
  BEGIN
    ALTER TABLE public.personas ADD CONSTRAINT fk_personas_grupo FOREIGN KEY (grupo_id) REFERENCES public.grupos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.grupos ADD CONSTRAINT grupos_lider_id_fkey FOREIGN KEY (lider_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.grupo_miembros ADD CONSTRAINT fk_grupo_miembros_grupo_id FOREIGN KEY (grupo_id) REFERENCES public.grupos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.grupo_miembros ADD CONSTRAINT fk_grupo_miembros_persona_id FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.asistencia ADD CONSTRAINT fk_asistencia_servicio_id FOREIGN KEY (servicio_id) REFERENCES public.servicios(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.asistencia ADD CONSTRAINT fk_asistencia_persona_id FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.finanzas ADD CONSTRAINT fk_finanzas_persona_id FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.inscripciones ADD CONSTRAINT fk_inscripciones_evento_id FOREIGN KEY (evento_id) REFERENCES public.eventos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.inscripciones ADD CONSTRAINT fk_inscripciones_persona_id FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.donaciones ADD CONSTRAINT fk_donaciones_persona_id FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.matriculas ADD CONSTRAINT fk_matriculas_curso_id FOREIGN KEY (curso_id) REFERENCES public.cursos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.matriculas ADD CONSTRAINT fk_matriculas_persona_id FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.certificados ADD CONSTRAINT fk_certificados_matricula_id FOREIGN KEY (matricula_id) REFERENCES public.matriculas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.certificados ADD CONSTRAINT fk_certificados_persona_id FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.certificados ADD CONSTRAINT fk_certificados_curso_id FOREIGN KEY (curso_id) REFERENCES public.cursos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.reportes_grupos ADD CONSTRAINT fk_reportes_grupos_grupo_id FOREIGN KEY (grupo_id) REFERENCES public.grupos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.peticiones_oracion ADD CONSTRAINT fk_peticiones_oracion_persona_id FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.persona_procesos ADD CONSTRAINT fk_persona_procesos_persona_id FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.persona_procesos ADD CONSTRAINT fk_persona_procesos_proceso_id FOREIGN KEY (proceso_id) REFERENCES public.procesos_crecimiento(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.reporte_asistencia ADD CONSTRAINT fk_reporte_asistencia_reporte_id FOREIGN KEY (reporte_id) REFERENCES public.reportes_grupos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.reporte_asistencia ADD CONSTRAINT fk_reporte_asistencia_persona_id FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.relaciones_familiares ADD CONSTRAINT fk_relaciones_familiares_persona_id FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.relaciones_familiares ADD CONSTRAINT fk_relaciones_familiares_familiar_id FOREIGN KEY (familiar_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.periodos_academicos ADD CONSTRAINT fk_periodos_academicos_escuela_id FOREIGN KEY (escuela_id) REFERENCES public.cursos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.materias ADD CONSTRAINT fk_materias_periodo_id FOREIGN KEY (periodo_id) REFERENCES public.periodos_academicos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.cortes_academicos ADD CONSTRAINT fk_cortes_academicos_periodo_id FOREIGN KEY (periodo_id) REFERENCES public.periodos_academicos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.items_calificables ADD CONSTRAINT fk_items_calificables_corte_id FOREIGN KEY (corte_id) REFERENCES public.cortes_academicos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.items_calificables ADD CONSTRAINT fk_items_calificables_materia_id FOREIGN KEY (materia_id) REFERENCES public.materias(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.calificaciones ADD CONSTRAINT fk_calificaciones_item_id FOREIGN KEY (item_id) REFERENCES public.items_calificables(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.calificaciones ADD CONSTRAINT fk_calificaciones_matricula_id FOREIGN KEY (matricula_id) REFERENCES public.matriculas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.asistencia_materias ADD CONSTRAINT fk_asistencia_materias_materia_id FOREIGN KEY (materia_id) REFERENCES public.materias(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.asistencia_materias ADD CONSTRAINT fk_asistencia_materias_matricula_id FOREIGN KEY (matricula_id) REFERENCES public.matriculas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.equipos_ministeriales ADD CONSTRAINT fk_equipos_ministeriales_lider_id FOREIGN KEY (lider_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.equipos_ministeriales ADD CONSTRAINT fk_equipos_ministeriales_parent_id FOREIGN KEY (parent_id) REFERENCES public.equipos_ministeriales(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.conceptos_pago ADD CONSTRAINT fk_conceptos_pago_curso_id FOREIGN KEY (curso_id) REFERENCES public.cursos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.pagos_matricula ADD CONSTRAINT fk_pagos_matricula_matricula_id FOREIGN KEY (matricula_id) REFERENCES public.matriculas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.recursos_academicos ADD CONSTRAINT fk_recursos_academicos_materia_id FOREIGN KEY (materia_id) REFERENCES public.materias(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.recursos_academicos ADD CONSTRAINT fk_recursos_academicos_maestro_id FOREIGN KEY (maestro_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.homologaciones ADD CONSTRAINT fk_homologaciones_persona_id FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.homologaciones ADD CONSTRAINT fk_homologaciones_materia_id FOREIGN KEY (materia_id) REFERENCES public.materias(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.evento_categorias ADD CONSTRAINT fk_evento_categorias_evento_id FOREIGN KEY (evento_id) REFERENCES public.eventos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.evento_encargados ADD CONSTRAINT fk_evento_encargados_evento_id FOREIGN KEY (evento_id) REFERENCES public.eventos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.evento_encargados ADD CONSTRAINT fk_evento_encargados_persona_id FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.evento_servidores ADD CONSTRAINT fk_evento_servidores_evento_id FOREIGN KEY (evento_id) REFERENCES public.eventos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.evento_servidores ADD CONSTRAINT fk_evento_servidores_persona_id FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.planificaciones_grupo ADD CONSTRAINT fk_planificaciones_grupo_grupo_id FOREIGN KEY (grupo_id) REFERENCES public.grupos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.tesoreria_ofrendas_cdp ADD CONSTRAINT fk_tesoreria_ofrendas_cdp_grupo_id FOREIGN KEY (grupo_id) REFERENCES public.grupos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.tesoreria_consignacion_historial ADD CONSTRAINT tesoreria_consignacion_historial_registro_id_fkey FOREIGN KEY (registro_id) REFERENCES public.tesoreria_ofrendas_cdp(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_pensum_semestres ADD CONSTRAINT fk_sem_pensum_semestres_programa_id FOREIGN KEY (programa_id) REFERENCES public.sem_programas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_materias ADD CONSTRAINT fk_sem_materias_programa_id FOREIGN KEY (programa_id) REFERENCES public.sem_programas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_materia_prerequisitos ADD CONSTRAINT fk_sem_materia_prerequisitos_materia_id FOREIGN KEY (materia_id) REFERENCES public.sem_materias(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_materia_prerequisitos ADD CONSTRAINT fk_sem_materia_prerequisitos_prerequisito_id FOREIGN KEY (prerequisito_id) REFERENCES public.sem_materias(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_pensum_materias ADD CONSTRAINT fk_sem_pensum_materias_semestre_id FOREIGN KEY (semestre_id) REFERENCES public.sem_pensum_semestres(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_pensum_materias ADD CONSTRAINT fk_sem_pensum_materias_materia_id FOREIGN KEY (materia_id) REFERENCES public.sem_materias(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_periodos ADD CONSTRAINT fk_sem_periodos_programa_id FOREIGN KEY (programa_id) REFERENCES public.sem_programas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_ofertas ADD CONSTRAINT fk_sem_ofertas_periodo_id FOREIGN KEY (periodo_id) REFERENCES public.sem_periodos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_ofertas ADD CONSTRAINT fk_sem_ofertas_materia_id FOREIGN KEY (materia_id) REFERENCES public.sem_materias(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_ofertas ADD CONSTRAINT fk_sem_ofertas_docente_persona_id FOREIGN KEY (docente_persona_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_inscripciones ADD CONSTRAINT fk_sem_inscripciones_persona_id FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_inscripciones ADD CONSTRAINT fk_sem_inscripciones_programa_id FOREIGN KEY (programa_id) REFERENCES public.sem_programas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_inscripciones ADD CONSTRAINT fk_sem_inscripciones_periodo_id FOREIGN KEY (periodo_id) REFERENCES public.sem_periodos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_inscripcion_materias ADD CONSTRAINT fk_sem_inscripcion_materias_inscripcion_id FOREIGN KEY (inscripcion_id) REFERENCES public.sem_inscripciones(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_inscripcion_materias ADD CONSTRAINT fk_sem_inscripcion_materias_oferta_id FOREIGN KEY (oferta_id) REFERENCES public.sem_ofertas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_inscripcion_materias ADD CONSTRAINT fk_sem_inscripcion_materias_materia_id FOREIGN KEY (materia_id) REFERENCES public.sem_materias(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_evaluaciones ADD CONSTRAINT fk_sem_evaluaciones_oferta_id FOREIGN KEY (oferta_id) REFERENCES public.sem_ofertas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_calificaciones ADD CONSTRAINT fk_sem_calificaciones_inscripcion_materia_id FOREIGN KEY (inscripcion_materia_id) REFERENCES public.sem_inscripcion_materias(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_calificaciones ADD CONSTRAINT fk_sem_calificaciones_evaluacion_id FOREIGN KEY (evaluacion_id) REFERENCES public.sem_evaluaciones(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_asistencias ADD CONSTRAINT fk_sem_asistencias_inscripcion_materia_id FOREIGN KEY (inscripcion_materia_id) REFERENCES public.sem_inscripcion_materias(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_recursos ADD CONSTRAINT fk_sem_recursos_programa_id FOREIGN KEY (programa_id) REFERENCES public.sem_programas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_recursos ADD CONSTRAINT fk_sem_recursos_materia_id FOREIGN KEY (materia_id) REFERENCES public.sem_materias(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_zoom_sesiones ADD CONSTRAINT fk_sem_zoom_sesiones_oferta_id FOREIGN KEY (oferta_id) REFERENCES public.sem_ofertas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_pagos_inscripcion ADD CONSTRAINT fk_sem_pagos_inscripcion_inscripcion_id FOREIGN KEY (inscripcion_id) REFERENCES public.sem_inscripciones(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_audit_log ADD CONSTRAINT fk_sem_audit_log_persona_id FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_audit_log ADD CONSTRAINT fk_sem_audit_log_inscripcion_id FOREIGN KEY (inscripcion_id) REFERENCES public.sem_inscripciones(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_audit_log ADD CONSTRAINT fk_sem_audit_log_oferta_id FOREIGN KEY (oferta_id) REFERENCES public.sem_ofertas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_audit_log ADD CONSTRAINT fk_sem_audit_log_materia_id FOREIGN KEY (materia_id) REFERENCES public.sem_materias(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_anuncios ADD CONSTRAINT fk_sem_anuncios_oferta_id FOREIGN KEY (oferta_id) REFERENCES public.sem_ofertas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_entregas ADD CONSTRAINT fk_sem_entregas_evaluacion_id FOREIGN KEY (evaluacion_id) REFERENCES public.sem_evaluaciones(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_entregas ADD CONSTRAINT fk_sem_entregas_inscripcion_materia_id FOREIGN KEY (inscripcion_materia_id) REFERENCES public.sem_inscripcion_materias(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_entregas ADD CONSTRAINT fk_sem_entregas_persona_id FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_foros ADD CONSTRAINT fk_sem_foros_oferta_id FOREIGN KEY (oferta_id) REFERENCES public.sem_ofertas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_foro_mensajes ADD CONSTRAINT fk_sem_foro_mensajes_foro_id FOREIGN KEY (foro_id) REFERENCES public.sem_foros(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_foro_mensajes ADD CONSTRAINT fk_sem_foro_mensajes_parent_id FOREIGN KEY (parent_id) REFERENCES public.sem_foro_mensajes(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_anuncios_lecturas ADD CONSTRAINT fk_sem_anuncios_lecturas_persona_id FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_materias_historial ADD CONSTRAINT fk_sem_materias_historial_materia_id FOREIGN KEY (materia_id) REFERENCES public.sem_materias(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.msg_messages ADD CONSTRAINT fk_msg_messages_thread_id FOREIGN KEY (thread_id) REFERENCES public.msg_threads(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.msg_participants ADD CONSTRAINT fk_msg_participants_thread_id FOREIGN KEY (thread_id) REFERENCES public.msg_threads(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.msg_attachments ADD CONSTRAINT fk_msg_attachments_message_id FOREIGN KEY (message_id) REFERENCES public.msg_messages(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.msg_drafts ADD CONSTRAINT fk_msg_drafts_reply_thread_id FOREIGN KEY (reply_thread_id) REFERENCES public.msg_threads(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.prog_ministerios ADD CONSTRAINT fk_prog_ministerios_lider_persona_id FOREIGN KEY (lider_persona_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.prog_cargos ADD CONSTRAINT fk_prog_cargos_ministerio_id FOREIGN KEY (ministerio_id) REFERENCES public.prog_ministerios(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.prog_servidores ADD CONSTRAINT fk_prog_servidores_ministerio_id FOREIGN KEY (ministerio_id) REFERENCES public.prog_ministerios(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.prog_servidores ADD CONSTRAINT fk_prog_servidores_persona_id FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.prog_servidores ADD CONSTRAINT fk_prog_servidores_cargo_id FOREIGN KEY (cargo_id) REFERENCES public.prog_cargos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.prog_eventos ADD CONSTRAINT fk_prog_eventos_servicio_id FOREIGN KEY (servicio_id) REFERENCES public.servicios(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.prog_asignaciones ADD CONSTRAINT fk_prog_asignaciones_evento_id FOREIGN KEY (evento_id) REFERENCES public.prog_eventos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.prog_asignaciones ADD CONSTRAINT fk_prog_asignaciones_ministerio_id FOREIGN KEY (ministerio_id) REFERENCES public.prog_ministerios(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.prog_asignaciones ADD CONSTRAINT fk_prog_asignaciones_cargo_id FOREIGN KEY (cargo_id) REFERENCES public.prog_cargos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.prog_asignaciones ADD CONSTRAINT fk_prog_asignaciones_persona_id FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.prog_disponibilidad ADD CONSTRAINT fk_prog_disponibilidad_persona_id FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.prog_audit_log ADD CONSTRAINT fk_prog_audit_log_evento_id FOREIGN KEY (evento_id) REFERENCES public.prog_eventos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.prog_reemplazos ADD CONSTRAINT fk_prog_reemplazos_asignacion_id FOREIGN KEY (asignacion_id) REFERENCES public.prog_asignaciones(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.prog_reemplazos ADD CONSTRAINT fk_prog_reemplazos_evento_id FOREIGN KEY (evento_id) REFERENCES public.prog_eventos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.prog_iso_templates ADD CONSTRAINT fk_prog_iso_templates_ministerio_id FOREIGN KEY (ministerio_id) REFERENCES public.prog_ministerios(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.prog_evento_textos ADD CONSTRAINT fk_prog_evento_textos_ministerio_id FOREIGN KEY (ministerio_id) REFERENCES public.prog_ministerios(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.prog_evento_textos ADD CONSTRAINT fk_prog_evento_textos_evento_id FOREIGN KEY (evento_id) REFERENCES public.prog_eventos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.tema_semana_versiones ADD CONSTRAINT fk_tema_semana_versiones_parent_version_id FOREIGN KEY (parent_version_id) REFERENCES public.tema_semana_versiones(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.cert_export_log ADD CONSTRAINT fk_cert_export_log_template_id FOREIGN KEY (template_id) REFERENCES public.cert_templates(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.cert_export_log ADD CONSTRAINT fk_cert_export_log_persona_id FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.alertas_importantes ADD CONSTRAINT fk_alertas_importantes_persona_id FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.alertas_importantes ADD CONSTRAINT fk_alertas_importantes_grupo_id FOREIGN KEY (grupo_id) REFERENCES public.grupos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.cumple_recordatorios ADD CONSTRAINT fk_cumple_recordatorios_persona_id FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.planilla_historial ADD CONSTRAINT fk_planilla_historial_servicio_id FOREIGN KEY (servicio_id) REFERENCES public.servicios(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.casas_de_paz ADD CONSTRAINT fk_casas_de_paz_red_id FOREIGN KEY (red_id) REFERENCES public.redes(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.leaders ADD CONSTRAINT fk_leaders_casa_de_paz_id FOREIGN KEY (casa_de_paz_id) REFERENCES public.casas_de_paz(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.discipulos ADD CONSTRAINT fk_discipulos_casa_de_paz_id FOREIGN KEY (casa_de_paz_id) REFERENCES public.casas_de_paz(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.discipulos ADD CONSTRAINT fk_discipulos_lider_id FOREIGN KEY (lider_id) REFERENCES public.leaders(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.progreso_discipulo ADD CONSTRAINT fk_progreso_discipulo_discipulo_id FOREIGN KEY (discipulo_id) REFERENCES public.discipulos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.progreso_discipulo ADD CONSTRAINT fk_progreso_discipulo_etapa_code FOREIGN KEY (etapa_code) REFERENCES public.etapas_discipulado(code) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.progreso_discipulo ADD CONSTRAINT fk_progreso_discipulo_updated_by FOREIGN KEY (updated_by) REFERENCES public.leaders(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.discipulo_visitas ADD CONSTRAINT fk_discipulo_visitas_discipulo_id FOREIGN KEY (discipulo_id) REFERENCES public.discipulos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.discipulo_visitas ADD CONSTRAINT fk_discipulo_visitas_lider_id FOREIGN KEY (lider_id) REFERENCES public.leaders(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.discipulo_actividades ADD CONSTRAINT fk_discipulo_actividades_discipulo_id FOREIGN KEY (discipulo_id) REFERENCES public.discipulos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.discipulo_actividades ADD CONSTRAINT fk_discipulo_actividades_lider_id FOREIGN KEY (lider_id) REFERENCES public.leaders(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.infantil_grupos_detalles ADD CONSTRAINT fk_infantil_grupos_detalles_grupo_id FOREIGN KEY (grupo_id) REFERENCES public.grupos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.infantil_detalles ADD CONSTRAINT fk_infantil_detalles_persona_id FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.infantil_acudientes ADD CONSTRAINT fk_infantil_acudientes_nino_id FOREIGN KEY (nino_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.infantil_acudientes ADD CONSTRAINT fk_infantil_acudientes_acudiente_id FOREIGN KEY (acudiente_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.infantil_clases ADD CONSTRAINT fk_infantil_clases_grupo_id FOREIGN KEY (grupo_id) REFERENCES public.grupos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.infantil_clases ADD CONSTRAINT fk_infantil_clases_maestro_id FOREIGN KEY (maestro_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.infantil_asistencia_checkin ADD CONSTRAINT fk_infantil_asistencia_checkin_nino_id FOREIGN KEY (nino_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.infantil_asistencia_checkin ADD CONSTRAINT fk_infantil_asistencia_checkin_grupo_id FOREIGN KEY (grupo_id) REFERENCES public.grupos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.infantil_asistencia_checkin ADD CONSTRAINT fk_infantil_asistencia_checkin_servicio_id FOREIGN KEY (servicio_id) REFERENCES public.servicios(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.infantil_asistencia_checkin ADD CONSTRAINT fk_infantil_asistencia_checkin_clase_id FOREIGN KEY (clase_id) REFERENCES public.infantil_clases(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.infantil_asistencia_checkin ADD CONSTRAINT fk_infantil_asistencia_checkin_entregado_por_id FOREIGN KEY (entregado_por_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.infantil_asistencia_checkin ADD CONSTRAINT fk_infantil_asistencia_checkin_recogido_por_id FOREIGN KEY (recogido_por_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.infantil_seguimiento ADD CONSTRAINT fk_infantil_seguimiento_nino_id FOREIGN KEY (nino_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.infantil_seguimiento ADD CONSTRAINT fk_infantil_seguimiento_responsable_id FOREIGN KEY (responsable_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.infantil_atenciones ADD CONSTRAINT fk_infantil_atenciones_nino_id FOREIGN KEY (nino_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.infantil_atenciones ADD CONSTRAINT fk_infantil_atenciones_checkin_id FOREIGN KEY (checkin_id) REFERENCES public.infantil_asistencia_checkin(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.infantil_atenciones ADD CONSTRAINT fk_infantil_atenciones_maestro_id FOREIGN KEY (maestro_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.infantil_atenciones ADD CONSTRAINT fk_infantil_atenciones_responsable_id FOREIGN KEY (responsable_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.academy_diplomados ADD CONSTRAINT fk_academy_diplomados_facultad_id FOREIGN KEY (facultad_id) REFERENCES public.academy_facultades(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.academy_modulos ADD CONSTRAINT fk_academy_modulos_diplomado_id FOREIGN KEY (diplomado_id) REFERENCES public.academy_diplomados(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.leaders_grupos ADD CONSTRAINT fk_leaders_grupos_leader_id FOREIGN KEY (leader_id) REFERENCES public.leaders(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.leaders_grupos ADD CONSTRAINT fk_leaders_grupos_grupo_id FOREIGN KEY (grupo_id) REFERENCES public.grupos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.infantil_seguimientos ADD CONSTRAINT fk_infantil_seguimientos_nino_id FOREIGN KEY (nino_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.infantil_seguimientos ADD CONSTRAINT fk_infantil_seguimientos_lider_id FOREIGN KEY (lider_id) REFERENCES public.personas(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.profiles ADD CONSTRAINT profiles_grupo_id_fkey FOREIGN KEY (grupo_id) REFERENCES public.grupos(id) ON DELETE SET NULL;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.pagos_matricula ADD CONSTRAINT fk_pagos_matricula_concepto_pago_id FOREIGN KEY (concepto_pago_id) REFERENCES public.conceptos_pago(id) ON DELETE CASCADE;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
END $$;

NOTIFY pgrst, 'reload schema';
