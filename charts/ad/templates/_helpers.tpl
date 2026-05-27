{{/*
Expand the name of the chart.
*/}}
{{- define "ad.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "ad.fullname" -}}
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
{{- define "ad.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ad.labels" -}}
helm.sh/chart: {{ include "ad.chart" . }}
{{ include "ad.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: opentelemetry-demo
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ad.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ad.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: ad
opentelemetry.io/name: ad
{{- end }}

{{/*
Service account name
*/}}
{{- define "ad.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ad.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Image reference
*/}}
{{- define "ad.image" -}}
{{- $tag := .Values.image.tag | default (printf "%s-ad" .Chart.AppVersion) -}}
{{- printf "%s:%s" .Values.image.repository $tag -}}
{{- end }}

{{/*
OTLP endpoint
*/}}
{{- define "ad.otelEndpoint" -}}
{{- if .Values.otel.exporterEndpoint }}
{{- .Values.otel.exporterEndpoint }}
{{- else }}
{{- printf "http://%s:4318" .Values.otel.collectorName }}
{{- end }}
{{- end }}
