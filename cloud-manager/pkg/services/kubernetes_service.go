package services

type Service struct {
	contextName string
}

func NewKubernetesService(contextName string) (*Service, error) {
	return &Service{contextName: contextName}, nil
}

func (s *Service) Drain() {
	for _, node := range client.GetNodes() { // kubectl client
		client.drain(node)
		s.waitUntilTearDown(node)
		s.verifyNew()
	}
}

func (s *Service) waitUntilTearDown() {

}

func (s *Service) verifyNew() {

}

// func (s *Service) delete(node string) {

// }
