//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Mariam Gbadamosi on 3/17/24.
//

import Foundation

struct TriviaAPIResponse: Decodable {
    let results: [TriviaAPIItem]
}

struct TriviaAPIItem: Decodable {
    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
}

class TriviaQuestionService {
    func fetchTriviaQuestions(completion: @escaping ([TriviaQuestion]?, Error?) -> Void) {
        let urlString = "https://opentdb.com/api.php?amount=10&type=multiple"
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(nil, error) }
                return
            }

            do {
                let response = try JSONDecoder().decode(TriviaAPIResponse.self, from: data)
                var newQuestions = [TriviaQuestion]()
                for item in response.results {
                    let question = TriviaQuestion(category: item.category,
                                                  question: item.question,
                                                  correctAnswer: item.correct_answer,
                                                  incorrectAnswers: item.incorrect_answers)
                    newQuestions.append(question)
                }

                DispatchQueue.main.async { completion(newQuestions, nil) }
            } catch {
                DispatchQueue.main.async { completion(nil, error) }
            }
        }

        task.resume()
    }
}
