//
//  PeopleListPresenter.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 23/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import Foundation

internal protocol PeopleListPresentationLogic {
    func presentLoad(response: PeopleListDataFlow.Load.Response)
    func presentNameInput(response: PeopleListDataFlow.NameInput.Response)
    func presentLoadingPeople(response: PeopleListDataFlow.LoadingPeople.Response)
    func presentSelectPeople(response: PeopleListDataFlow.SelectPeople.Response)
    func presentUpdateStatus(response: PeopleListDataFlow.UpdateStatus.Response)
}

internal class PeopleListPresenter: PeopleListPresentationLogic {

    // MARK: - Properties
    
    weak var viewController: PeopleListControllerLogic?

    // MARK: - PeopleListPresentationLogic

    func presentLoad(response: PeopleListDataFlow.Load.Response) {
        let items: [PeopleListDataFlow.Item] = makeMessageItem(
            title: "Введите имя персонажа\n в поисковой строке"
        )
        let viewModel = PeopleListDataFlow.Load.ViewModel(items: items)
        viewController?.displayLoad(viewModel: viewModel)
    }
    
    func presentNameInput(response: PeopleListDataFlow.NameInput.Response) {
        let viewModel: PeopleListDataFlow.NameInput.ViewModel
        
        switch response {
        case .success(let people):
            let items: [PeopleListDataFlow.Item]
            if !people.isEmpty {
                items = makeItems(people: people)
            } else {
                items = makeMessageItem(
                    title: "Персонаж по введенному\n имени не найден"
                )
            }
            viewModel = .success(items: items)
        case .failure(let error):
            switch error {
            case .createRealmObjectError:
                viewModel = .error(title: "Ошибка", description: "Не удалось сохранить данные")
            case .decoding:
                viewModel = .error(title: "Ошибка", description: "Ошибка в модели данных")
            default:
                viewModel = .error(title: "Ошибка", description: "Не удалось загрузить данные")
            }
        }
        
        viewController?.displayNameInput(viewModel: viewModel)
    }
    
    func presentLoadingPeople(response: PeopleListDataFlow.LoadingPeople.Response) {
        let viewModel = PeopleListDataFlow.LoadingPeople.ViewModel(items: [.loading])
        viewController?.displayLoadingPeople(viewModel: viewModel)
    }
    
    func presentSelectPeople(response: PeopleListDataFlow.SelectPeople.Response) {
        let viewModel = PeopleListDataFlow.SelectPeople.ViewModel(people: response.people)
        viewController?.displaySelectPeople(viewModel: viewModel)
    }
    
    func presentUpdateStatus(response: PeopleListDataFlow.UpdateStatus.Response) {
        let items: [PeopleListDataFlow.Item] = makeMessageItem(
            title: "Введите имя персонажа\n в поисковой строке"
        )
        let viewModel = PeopleListDataFlow.UpdateStatus.ViewModel(items: items)
        viewController?.displayUpdateStatus(viewModel: viewModel)
    }
    
    private func makeMessageItem(title: String) -> [PeopleListDataFlow.Item] {
        var items: [PeopleListDataFlow.Item] = []
        items.append(.message(title: title))
        
        return items
    }
    
    private func makeItems(people: [People]) -> [PeopleListDataFlow.Item] {
        let people: [PeopleListDataFlow.Item] = people.map {
            PeopleListDataFlow.Item.people(people: mapItem(people: $0))
        }
        return people
    }
    
    private func mapItem(people: People) -> PeopleListDataFlow.PeopleModel {
        return PeopleListDataFlow.PeopleModel(
            title: "\(people.name), \(people.birthYear)",
            created: people.created.toString(dateFormat: "dd MMMM, yyyy")
        )
    }
    
}
