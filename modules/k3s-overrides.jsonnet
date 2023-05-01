local utils = import '../utils.libsonnet';
local vars = import '../vars.jsonnet';
local k = import 'ksonnet/ksonnet.beta.4/k.libsonnet';
local service = k.core.v1.service;
local servicePort = k.core.v1.service.mixin.spec.portsType;

{
  prometheus+:: {
    kubeControllerManagerPrometheusDiscoveryEndpoints:
      utils.newEndpoint('kube-controller-manager-prometheus-discovery', 'kube-system', vars.k3s.master_ip, 'http-metrics', 10257),

    kubeSchedulerPrometheusDiscoveryEndpoints:
      utils.newEndpoint('kube-scheduler-prometheus-discovery', 'kube-system', vars.k3s.master_ip, 'http-metrics', 10259),

    kubeControllerManagerPrometheusDiscoveryService:
      service.new('kube-controller-manager-prometheus-discovery', {}, servicePort.newNamed('http-metrics', 10257, 10257)) +
      service.mixin.metadata.withNamespace('kube-system') +
      service.mixin.metadata.withLabels({ 'k8s-app': 'kube-controller-manager' }) +
      service.mixin.spec.withClusterIp('None'),

    kubeSchedulerPrometheusDiscoveryService:
      service.new('kube-scheduler-prometheus-discovery', {}, servicePort.newNamed('http-metrics', 10259, 10259)) +
      service.mixin.metadata.withNamespace('kube-system') +
      service.mixin.metadata.withLabels({ 'k8s-app': 'kube-scheduler' }) +
      service.mixin.spec.withClusterIp('None'),
  },
}
