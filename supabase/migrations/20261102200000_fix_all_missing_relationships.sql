-- ==============================================================================
-- MIGRACIÓN DEFINITIVA: RESOLVER TODAS LAS RELACIONES (FOREIGN KEYS) Y COLUMNAS
-- Ejecutar este script completo en: Supabase Studio -> SQL Editor -> Run
-- ==============================================================================

-- 1. COLUMNAS FALTANTES QUE CONSUME EL FRONTEND
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS email text;
UPDATE public.profiles p SET email = u.email FROM auth.users u WHERE p.user_id = u.id AND p.email IS NULL;

ALTER TABLE public.personas ADD COLUMN IF NOT EXISTS correo text;
ALTER TABLE public.personas ADD COLUMN IF NOT EXISTS full_name text;
ALTER TABLE public.personas ADD COLUMN IF NOT EXISTS sede text DEFAULT 'Principal';
UPDATE public.personas SET correo = email WHERE correo IS NULL AND email IS NOT NULL;
UPDATE public.personas SET full_name = trim(concat(nombres, ' ', coalesce(apellidos, ''))) WHERE full_name IS NULL;

ALTER TABLE public.role_permissions ADD COLUMN IF NOT EXISTS action_key text;
ALTER TABLE public.pagos_matricula ADD COLUMN IF NOT EXISTS concepto_pago_id uuid;
ALTER TABLE public.eventos ADD COLUMN IF NOT EXISTS sede text DEFAULT 'Principal';
ALTER TABLE public.inscripciones ADD COLUMN IF NOT EXISTS confirmado boolean DEFAULT false;
ALTER TABLE public.leaders ADD COLUMN IF NOT EXISTS telefono text;
UPDATE public.leaders SET telefono = phone WHERE telefono IS NULL AND phone IS NOT NULL;

-- 2. LIMPIEZA DE HUÉRFANOS EN TABLAS CLAVE (Pone NULL si el ID no existe en personas)
UPDATE public.sem_inscripciones SET persona_id = NULL WHERE persona_id IS NOT NULL AND persona_id NOT IN (SELECT id FROM public.personas);
UPDATE public.matriculas SET persona_id = NULL WHERE persona_id IS NOT NULL AND persona_id NOT IN (SELECT id FROM public.personas);
UPDATE public.peticiones_oracion SET persona_id = NULL WHERE persona_id IS NOT NULL AND persona_id NOT IN (SELECT id FROM public.personas);
UPDATE public.profiles SET persona_id = NULL WHERE persona_id IS NOT NULL AND persona_id NOT IN (SELECT id FROM public.personas);
UPDATE public.grupo_miembros SET persona_id = NULL WHERE persona_id IS NOT NULL AND persona_id NOT IN (SELECT id FROM public.personas);
UPDATE public.reporte_asistencia SET persona_id = NULL WHERE persona_id IS NOT NULL AND persona_id NOT IN (SELECT id FROM public.personas);

-- 3. CREACIÓN DE FOREIGN KEYS FALTANTES (CON 'NOT VALID' PARA EVITAR CONFLICTOS CON DATOS EXISTENTES)
DO $$
BEGIN
  BEGIN
    ALTER TABLE public.alertas_importantes ADD CONSTRAINT alertas_importantes_grupo_id_fkey FOREIGN KEY (grupo_id) REFERENCES public.grupos(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.alertas_importantes ADD CONSTRAINT alertas_importantes_persona_id_fkey FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.asistencia ADD CONSTRAINT asistencia_persona_id_fkey FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.asistencia_materias ADD CONSTRAINT asistencia_materias_materia_id_fkey FOREIGN KEY (materia_id) REFERENCES public.materias(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.asistencia_materias ADD CONSTRAINT asistencia_materias_matricula_id_fkey FOREIGN KEY (matricula_id) REFERENCES public.matriculas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.categorias_financieras ADD CONSTRAINT categorias_financieras_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.categorias_financieras(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.certificados ADD CONSTRAINT certificados_matricula_id_fkey FOREIGN KEY (matricula_id) REFERENCES public.matriculas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.certificados ADD CONSTRAINT certificados_persona_id_fkey FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.conceptos_pago ADD CONSTRAINT conceptos_pago_curso_id_fkey FOREIGN KEY (curso_id) REFERENCES public.cursos(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.cortes_academicos ADD CONSTRAINT cortes_academicos_periodo_id_fkey FOREIGN KEY (periodo_id) REFERENCES public.periodos_academicos(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.cumple_recordatorios ADD CONSTRAINT cumple_recordatorios_persona_id_fkey FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.discipulos ADD CONSTRAINT discipulos_casa_de_paz_id_fkey FOREIGN KEY (casa_de_paz_id) REFERENCES public.grupos(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.equipos_ministeriales ADD CONSTRAINT equipos_ministeriales_lider_id_fkey FOREIGN KEY (lider_id) REFERENCES public.personas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.equipos_ministeriales ADD CONSTRAINT equipos_ministeriales_lider2_id_fkey FOREIGN KEY (lider2_id) REFERENCES public.personas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.equipos_ministeriales ADD CONSTRAINT equipos_ministeriales_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.equipos_ministeriales(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.evento_categorias ADD CONSTRAINT evento_categorias_evento_id_fkey FOREIGN KEY (evento_id) REFERENCES public.eventos(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.evento_encargados ADD CONSTRAINT evento_encargados_evento_id_fkey FOREIGN KEY (evento_id) REFERENCES public.eventos(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.evento_encargados ADD CONSTRAINT evento_encargados_persona_id_fkey FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.evento_servidores ADD CONSTRAINT evento_servidores_evento_id_fkey FOREIGN KEY (evento_id) REFERENCES public.eventos(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.evento_servidores ADD CONSTRAINT evento_servidores_persona_id_fkey FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.grupo_miembros ADD CONSTRAINT grupo_miembros_persona_id_fkey FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.grupos ADD CONSTRAINT grupos_lider_id_fkey FOREIGN KEY (lider_id) REFERENCES public.personas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.homologaciones ADD CONSTRAINT homologaciones_materia_id_fkey FOREIGN KEY (materia_id) REFERENCES public.materias(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.homologaciones ADD CONSTRAINT homologaciones_persona_id_fkey FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.leaders ADD CONSTRAINT leaders_casa_de_paz_id_fkey FOREIGN KEY (casa_de_paz_id) REFERENCES public.grupos(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.materias ADD CONSTRAINT materias_aula_id_fkey FOREIGN KEY (aula_id) REFERENCES public.aulas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.materias ADD CONSTRAINT materias_maestro_id_fkey FOREIGN KEY (maestro_id) REFERENCES public.personas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.materias ADD CONSTRAINT materias_periodo_id_fkey FOREIGN KEY (periodo_id) REFERENCES public.periodos_academicos(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.matriculas ADD CONSTRAINT matriculas_materia_id_fkey FOREIGN KEY (materia_id) REFERENCES public.materias(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.matriculas ADD CONSTRAINT matriculas_periodo_id_fkey FOREIGN KEY (periodo_id) REFERENCES public.periodos_academicos(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.matriculas ADD CONSTRAINT matriculas_persona_id_fkey FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.msg_attachments ADD CONSTRAINT msg_attachments_message_id_fkey FOREIGN KEY (message_id) REFERENCES public.msg_messages(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.msg_drafts ADD CONSTRAINT msg_drafts_reply_thread_id_fkey FOREIGN KEY (reply_thread_id) REFERENCES public.msg_threads(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.msg_messages ADD CONSTRAINT msg_messages_thread_id_fkey FOREIGN KEY (thread_id) REFERENCES public.msg_threads(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.msg_participants ADD CONSTRAINT msg_participants_thread_id_fkey FOREIGN KEY (thread_id) REFERENCES public.msg_threads(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.periodos_academicos ADD CONSTRAINT periodos_academicos_escuela_id_fkey FOREIGN KEY (escuela_id) REFERENCES public.cursos(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.persona_procesos ADD CONSTRAINT persona_procesos_persona_id_fkey FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.persona_procesos ADD CONSTRAINT persona_procesos_proceso_id_fkey FOREIGN KEY (proceso_id) REFERENCES public.procesos_crecimiento(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.peticiones_oracion ADD CONSTRAINT peticiones_oracion_persona_id_fkey FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.planilla_historial ADD CONSTRAINT planilla_historial_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.planilla_historial(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.planilla_historial ADD CONSTRAINT planilla_historial_servicio_id_fkey FOREIGN KEY (servicio_id) REFERENCES public.servicios(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.profiles ADD CONSTRAINT profiles_persona_id_fkey FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.prog_asignaciones ADD CONSTRAINT prog_asignaciones_cargo_id_fkey FOREIGN KEY (cargo_id) REFERENCES public.prog_cargos(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.prog_asignaciones ADD CONSTRAINT prog_asignaciones_ministerio_id_fkey FOREIGN KEY (ministerio_id) REFERENCES public.prog_ministerios(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.prog_asignaciones ADD CONSTRAINT prog_asignaciones_persona_id_fkey FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.prog_audit_log ADD CONSTRAINT prog_audit_log_evento_id_fkey FOREIGN KEY (evento_id) REFERENCES public.prog_eventos(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.prog_cargos ADD CONSTRAINT prog_cargos_ministerio_id_fkey FOREIGN KEY (ministerio_id) REFERENCES public.prog_ministerios(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.prog_disponibilidad ADD CONSTRAINT prog_disponibilidad_persona_id_fkey FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.prog_evento_textos ADD CONSTRAINT prog_evento_textos_evento_id_fkey FOREIGN KEY (evento_id) REFERENCES public.prog_eventos(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.prog_evento_textos ADD CONSTRAINT prog_evento_textos_ministerio_id_fkey FOREIGN KEY (ministerio_id) REFERENCES public.prog_ministerios(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.prog_eventos ADD CONSTRAINT prog_eventos_servicio_id_fkey FOREIGN KEY (servicio_id) REFERENCES public.servicios(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.prog_iso_templates ADD CONSTRAINT prog_iso_templates_ministerio_id_fkey FOREIGN KEY (ministerio_id) REFERENCES public.prog_ministerios(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.prog_ministerios ADD CONSTRAINT prog_ministerios_lider_persona_id_fkey FOREIGN KEY (lider_persona_id) REFERENCES public.personas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.prog_reemplazos ADD CONSTRAINT prog_reemplazos_asignacion_id_fkey FOREIGN KEY (asignacion_id) REFERENCES public.prog_asignaciones(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.prog_reemplazos ADD CONSTRAINT prog_reemplazos_evento_id_fkey FOREIGN KEY (evento_id) REFERENCES public.prog_eventos(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.prog_servidores ADD CONSTRAINT prog_servidores_cargo_id_fkey FOREIGN KEY (cargo_id) REFERENCES public.prog_cargos(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.prog_servidores ADD CONSTRAINT prog_servidores_ministerio_id_fkey FOREIGN KEY (ministerio_id) REFERENCES public.prog_ministerios(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.prog_servidores ADD CONSTRAINT prog_servidores_persona_id_fkey FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.recursos_academicos ADD CONSTRAINT recursos_academicos_maestro_id_fkey FOREIGN KEY (maestro_id) REFERENCES public.personas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.recursos_academicos ADD CONSTRAINT recursos_academicos_materia_id_fkey FOREIGN KEY (materia_id) REFERENCES public.materias(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.relaciones_familiares ADD CONSTRAINT relaciones_familiares_familiar_id_fkey FOREIGN KEY (familiar_id) REFERENCES public.personas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.relaciones_familiares ADD CONSTRAINT relaciones_familiares_persona_id_fkey FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.reporte_asistencia ADD CONSTRAINT reporte_asistencia_persona_id_fkey FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.reporte_asistencia ADD CONSTRAINT reporte_asistencia_reporte_id_fkey FOREIGN KEY (reporte_id) REFERENCES public.reportes_grupos(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_anuncios ADD CONSTRAINT sem_anuncios_oferta_id_fkey FOREIGN KEY (oferta_id) REFERENCES public.sem_ofertas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_anuncios_lecturas ADD CONSTRAINT sem_anuncios_lecturas_persona_id_fkey FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_asistencias ADD CONSTRAINT sem_asistencias_inscripcion_materia_id_fkey FOREIGN KEY (inscripcion_materia_id) REFERENCES public.sem_inscripcion_materias(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_audit_log ADD CONSTRAINT sem_audit_log_inscripcion_id_fkey FOREIGN KEY (inscripcion_id) REFERENCES public.sem_inscripciones(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_audit_log ADD CONSTRAINT sem_audit_log_materia_id_fkey FOREIGN KEY (materia_id) REFERENCES public.sem_materias(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_audit_log ADD CONSTRAINT sem_audit_log_oferta_id_fkey FOREIGN KEY (oferta_id) REFERENCES public.sem_ofertas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_audit_log ADD CONSTRAINT sem_audit_log_persona_id_fkey FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_calificaciones ADD CONSTRAINT sem_calificaciones_evaluacion_id_fkey FOREIGN KEY (evaluacion_id) REFERENCES public.sem_evaluaciones(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_calificaciones ADD CONSTRAINT sem_calificaciones_inscripcion_materia_id_fkey FOREIGN KEY (inscripcion_materia_id) REFERENCES public.sem_inscripcion_materias(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_entregas ADD CONSTRAINT sem_entregas_evaluacion_id_fkey FOREIGN KEY (evaluacion_id) REFERENCES public.sem_evaluaciones(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_entregas ADD CONSTRAINT sem_entregas_persona_id_fkey FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_foro_mensajes ADD CONSTRAINT sem_foro_mensajes_foro_id_fkey FOREIGN KEY (foro_id) REFERENCES public.sem_foros(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_foro_mensajes ADD CONSTRAINT sem_foro_mensajes_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.sem_foro_mensajes(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_foros ADD CONSTRAINT sem_foros_oferta_id_fkey FOREIGN KEY (oferta_id) REFERENCES public.sem_ofertas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_inscripcion_materias ADD CONSTRAINT sem_inscripcion_materias_oferta_id_fkey FOREIGN KEY (oferta_id) REFERENCES public.sem_ofertas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_inscripciones ADD CONSTRAINT sem_inscripciones_periodo_ingreso_id_fkey FOREIGN KEY (periodo_ingreso_id) REFERENCES public.sem_periodos(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_inscripciones ADD CONSTRAINT sem_inscripciones_persona_id_fkey FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_materia_prerequisitos ADD CONSTRAINT sem_materia_prerequisitos_materia_id_fkey FOREIGN KEY (materia_id) REFERENCES public.sem_materias(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_materia_prerequisitos ADD CONSTRAINT sem_materia_prerequisitos_prerequisito_id_fkey FOREIGN KEY (prerequisito_id) REFERENCES public.sem_materias(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_materias ADD CONSTRAINT sem_materias_programa_id_fkey FOREIGN KEY (programa_id) REFERENCES public.sem_programas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_materias_historial ADD CONSTRAINT sem_materias_historial_materia_id_fkey FOREIGN KEY (materia_id) REFERENCES public.sem_materias(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_ofertas ADD CONSTRAINT sem_ofertas_docente_persona_id_fkey FOREIGN KEY (docente_persona_id) REFERENCES public.personas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_ofertas ADD CONSTRAINT sem_ofertas_materia_id_fkey FOREIGN KEY (materia_id) REFERENCES public.sem_materias(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_ofertas ADD CONSTRAINT sem_ofertas_periodo_id_fkey FOREIGN KEY (periodo_id) REFERENCES public.sem_periodos(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_pagos_inscripcion ADD CONSTRAINT sem_pagos_inscripcion_inscripcion_id_fkey FOREIGN KEY (inscripcion_id) REFERENCES public.sem_inscripciones(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_pensum_materias ADD CONSTRAINT sem_pensum_materias_materia_id_fkey FOREIGN KEY (materia_id) REFERENCES public.sem_materias(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_pensum_semestres ADD CONSTRAINT sem_pensum_semestres_programa_id_fkey FOREIGN KEY (programa_id) REFERENCES public.sem_programas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_periodos ADD CONSTRAINT sem_periodos_programa_id_fkey FOREIGN KEY (programa_id) REFERENCES public.sem_programas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_recursos ADD CONSTRAINT sem_recursos_periodo_id_fkey FOREIGN KEY (periodo_id) REFERENCES public.sem_periodos(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_recursos ADD CONSTRAINT sem_recursos_programa_id_fkey FOREIGN KEY (programa_id) REFERENCES public.sem_programas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.sem_zoom_sesiones ADD CONSTRAINT sem_zoom_sesiones_oferta_id_fkey FOREIGN KEY (oferta_id) REFERENCES public.sem_ofertas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.servicio_ministerios ADD CONSTRAINT servicio_ministerios_ministerio_id_fkey FOREIGN KEY (ministerio_id) REFERENCES public.prog_ministerios(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.servicio_ministerios ADD CONSTRAINT servicio_ministerios_servicio_id_fkey FOREIGN KEY (servicio_id) REFERENCES public.servicios(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.servicio_programacion ADD CONSTRAINT servicio_programacion_ministerio_id_fkey FOREIGN KEY (ministerio_id) REFERENCES public.prog_ministerios(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.servicio_programacion ADD CONSTRAINT servicio_programacion_persona_id_fkey FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.servicio_programacion ADD CONSTRAINT servicio_programacion_servicio_id_fkey FOREIGN KEY (servicio_id) REFERENCES public.servicios(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.tema_semana_versiones ADD CONSTRAINT tema_semana_versiones_parent_version_id_fkey FOREIGN KEY (parent_version_id) REFERENCES public.tema_semana_versiones(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.tesoreria_consignacion_historial ADD CONSTRAINT tesoreria_consignacion_historial_consignacion_semanal_id_fkey FOREIGN KEY (consignacion_semanal_id) REFERENCES public.tesoreria_consignacion_semanal(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.tesoreria_consignacion_historial ADD CONSTRAINT tesoreria_consignacion_historial_registro_id_fkey FOREIGN KEY (registro_id) REFERENCES public.tesoreria_ofrendas_cdp(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.tesoreria_ofrendas_cdp ADD CONSTRAINT tesoreria_ofrendas_cdp_grupo_id_fkey FOREIGN KEY (grupo_id) REFERENCES public.grupos(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.persona_procesos ADD CONSTRAINT fk_persona_procesos_persona_id FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.persona_procesos ADD CONSTRAINT fk_persona_procesos_proceso_id FOREIGN KEY (proceso_id) REFERENCES public.procesos_crecimiento(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.profiles ADD CONSTRAINT profiles_grupo_id_fkey FOREIGN KEY (grupo_id) REFERENCES public.grupos(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.pagos_matricula ADD CONSTRAINT fk_pagos_matricula_concepto_pago_id FOREIGN KEY (concepto_pago_id) REFERENCES public.conceptos_pago(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.grupo_miembros ADD CONSTRAINT fk_grupo_miembros_persona_id FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.reporte_asistencia ADD CONSTRAINT fk_reporte_asistencia_reporte_id FOREIGN KEY (reporte_id) REFERENCES public.reportes_grupos(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
  BEGIN
    ALTER TABLE public.reporte_asistencia ADD CONSTRAINT fk_reporte_asistencia_persona_id FOREIGN KEY (persona_id) REFERENCES public.personas(id) ON DELETE SET NULL NOT VALID;
  EXCEPTION WHEN duplicate_object THEN NULL; WHEN OTHERS THEN NULL; END;
END $$;

-- 4. RECARGAR CACHÉ DE POSTGREST
NOTIFY pgrst, 'reload schema';
