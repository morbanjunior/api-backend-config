{{/*
Base name of the chart, overridable.
*/}}
{{- define "api-backend.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Release-qualified base name shared by every component.
*/}}
{{- define "api-backend.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else if contains .Chart.Name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Per-component name, e.g. "tasks-api-backend-backend".

Every helper below takes a dict of (root, component) instead of the usual bare
context. That is what lets backend and frontend share one implementation rather
than duplicating near-identical blocks of labels and selectors.

Usage: {{ include "api-backend.componentName" (dict "root" $ "component" "backend") }}
*/}}
{{- define "api-backend.componentName" -}}
{{- printf "%s-%s" (include "api-backend.fullname" .root) .component | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Selector labels: the minimal, immutable identity of a component.

Kept deliberately small. A Deployment's selector is immutable once created, so
anything that can change over time (chart version, app version) must stay out
of here or upgrades start failing.
*/}}
{{- define "api-backend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "api-backend.name" .root }}
app.kubernetes.io/instance: {{ .root.Release.Name }}
app.kubernetes.io/component: {{ .component }}
{{- end }}

{{/*
Full label set: selector labels plus metadata that may change between releases.
*/}}
{{- define "api-backend.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .root.Chart.Name .root.Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{ include "api-backend.selectorLabels" . }}
app.kubernetes.io/version: {{ .root.Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .root.Release.Service }}
{{- end }}
