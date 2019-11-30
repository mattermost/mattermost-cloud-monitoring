package providers

func NewAwsProvider(name string) (*Provider, error) {
	return &Provider{name: name}, nil
}

func (m *Provider) GetName() string {
	return m.name
}
