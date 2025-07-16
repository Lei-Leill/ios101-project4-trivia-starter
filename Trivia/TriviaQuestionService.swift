//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Lei Lei on 7/10/25.
//


//
//import Foundation
//
//// type, question, answers (can be 4 and can be 2)
//class TriviaQuestionService {
//    static func fetchForecast(completion: ((TriviaQuestion) -> Void)? = nil) {
//        
//        let url = URL(string: "https://opentdb.com/api.php?amount=5")!
//        // create a data task and pass in the URL
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            // this closure is fired when the response is received
//            guard error == nil else {
//                assertionFailure("Error: \(error!.localizedDescription)")
//                return
//            }
//            guard let httpResponse = response as? HTTPURLResponse else {
//                assertionFailure("Invalid response")
//                return
//            }
//            guard let data = data, httpResponse.statusCode == 200 else {
//                assertionFailure("Invalid response status code: \(httpResponse.statusCode)")
//                return
//            }
//            // at this point, `data` contains the data received from the response
//            let triviaQuestion = parse(data: data)
//                  // this response will be used to change the UI, so it must happen on the main thread
//                  DispatchQueue.main.async {
//                    completion?(triviaQuestion) // call the completion closure and pass in the forecast data model
//                  }
//            let decoder = JSONDecoder()
//                  let response = try! decoder.decode(WeatherAPIResponse.self, from: data)
//                  DispatchQueue.main.async {
//                    completion?(response.currentWeather)
//                  }
//        }
//        task.resume() // resume the task and fire the request
//    }
//    private static func parse(data: Data) -> TriviaQuestion {
//        // transform the data we received into a dictionary [String: Any]
//        let jsonDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
//        
//        let category = jsonDictionary["category"] as! String
//        let question = jsonDictionary["question"] as! String
//        let correctAnswer = jsonDictionary["correct_answer"] as! String
//        let incorrectAnswers = jsonDictionary["incorrect_answers"] as! [String]
//        return TriviaQuestion(category: category, question: question, correctAnswer: correctAnswer, incorrectAnswers: incorrectAnswers)
//        
//      }
//}


import Foundation

class TriviaQuestionService {
    static func fetchQuestions(completion: @escaping ([TriviaQuestion]) -> Void) {
        let url = URL(string: "https://opentdb.com/api.php?amount=5")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print("❌ Error: \(error!.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("❌ Invalid response")
                return
            }

            guard let data = data else {
                print("❌ No data received")
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(TriviaAPIResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse.results)
                }
            } catch {
                print("❌ JSON decode error: \(error)")
            }
        }
        task.resume()
    }
}
