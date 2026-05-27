{{/*
Expand the name of the chart.
*/}}
{{- define "shipping.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "shipping.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Chart label
*/}}
{{- define "shipping.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "shipping.labels" -}}
helm.sh/chart: {{ include "shipping.chart" . }}
{{ include "shipping.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: opentelemetry-demo
{{- end }}

{{/*
Selector labels
*/}}
{{- define "shipping.selectorLabels" -}}
app.kubernetes.io/name: {{ include "shipping.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: shipping
opentelemetry.io/name: shipping
{{- end }}

{{/*
Service account name
*/}}
{{- define "shipping.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "shipping.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Image reference
*/}}
{{- define "shipping.image" -}}
{{- $tag := .Values.image.tag | default (printf "%s-shipping" .Chart.AppVersion) -}}
{{- printf "%s:%s" .Values.image.repository $tag -}}
{{- end }}

{{/*
OTLP endpoint
*/}}
{{- define "shipping.otelEndpoint" -}}
{{- if .Values.otel.exporterEndpoint }}
{{- .Values.otel.exporterEndpoint }}
{{- else }}
{{- printf "http://%s:4318" .Values.otel.collectorName }}
{{- end }}
{{- end }}
