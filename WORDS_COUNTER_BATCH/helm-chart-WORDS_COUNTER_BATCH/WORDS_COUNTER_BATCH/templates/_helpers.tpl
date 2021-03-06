{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "WORDS_COUNTER_BATCH.name" -}}
{{- default "words-count" .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "WORDS_COUNTER_BATCH.cleanup.name" -}}
{{- default "clean-jobs" .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "WORDS_COUNTER_BATCH.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "WORDS_COUNTER_BATCH.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "WORDS_COUNTER_BATCH.labels" -}}
{{ include "WORDS_COUNTER_BATCH.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "WORDS_COUNTER_BATCH.selectorLabels" -}}
app.kubernetes.io/name: {{ include "WORDS_COUNTER_BATCH.name" . }}
{{- end -}}

{{/*
cleanup Selector labels
*/}}
{{- define "WORDS_COUNTER_BATCH.cleanup.selectorLabels" -}}
role: {{ include "WORDS_COUNTER_BATCH.cleanup.name" . }}-completed
{{- end -}}
