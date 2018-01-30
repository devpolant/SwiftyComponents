//
//  MKMapView+ViewModels.swift
//  Components
//
//  Created by Anton Poltoratskyi on 29.01.18.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import MapKit

public protocol AnnotationViewModel: CellViewModel where Cell: MKAnnotationView { }

extension MKMapView {
    
    open func dequeueReusableAnnotationView(withModel viewModel: AnyCellViewModel, for annotation: MKAnnotation) -> MKAnnotationView {
        let identifier = type(of: viewModel).typeIdentifier
        let annotationView = dequeueReusableAnnotationView(withIdentifier: identifier, for: annotation)
        viewModel.setup(cell: annotationView)
        return annotationView
    }
    
    open func register<T: AnnotationViewModel>(viewModel: T.Type) {
        register(T.Cell.self, forAnnotationViewWithReuseIdentifier: T.typeIdentifier)
    }
}
