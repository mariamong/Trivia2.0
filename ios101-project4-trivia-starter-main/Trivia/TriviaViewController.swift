//
//  ViewController.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import UIKit

class TriviaViewController: UIViewController {
  
  @IBOutlet weak var currentQuestionNumberLabel: UILabel!
  @IBOutlet weak var questionContainerView: UIView!
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var answerButton0: UIButton!
  @IBOutlet weak var answerButton1: UIButton!
  @IBOutlet weak var answerButton2: UIButton!
  @IBOutlet weak var answerButton3: UIButton!
  
    
  private var questions = [TriviaQuestion]()
  private var currQuestionIndex = 0
  private var numCorrectQuestions = 0
  private var triviaService: TriviaQuestionService!


  override func viewDidLoad() {
    super.viewDidLoad()
    addGradient()
    questionContainerView.layer.cornerRadius = 8.0
    triviaService = TriviaQuestionService() // Instantiate the service
    fetchTriviaQuestions() // Call your method to fetch questions
      
     let trivia1 = TriviaQuestion(category: "General Knowledge", question: "Computer manufacturer Compaq was acquired for $25 billion dollars in 2002 by which company?", correctAnswer: "Hewlett-Packard", incorrectAnswers: ["Toshiba","Asus","Dell"])
      let trivia2 = TriviaQuestion(category: "General Knowledge", question: "This field is sometimes known as &ldquo;The Dismal Science.&rdquo;", correctAnswer: "Economics", incorrectAnswers: ["Philosophy","Politics","Physics"])
      let trivia3 = TriviaQuestion(category: "General Knowledge", question: "What is the highest number of Michelin stars a restaurant can receive?", correctAnswer: "Three", incorrectAnswers: ["Four","Five","Six"])
      let trivia4 = TriviaQuestion(category: "General Knowledge", question: "The scientific name for the Southern Lights is Aurora Australis?", correctAnswer: "True", incorrectAnswers: ["False"])
      let trivia5 = TriviaQuestion(category: "General Knowledge", question: "Albert Einstein had trouble with mathematics when he was in school.", correctAnswer: "False", incorrectAnswers: ["True"])
    
    let triviaQuestions = [trivia1, trivia2, trivia3, trivia4, trivia5]
      questions.append(contentsOf: triviaQuestions)

  }
    
    private func fetchTriviaQuestions() {
        triviaService.fetchTriviaQuestions { [weak self] (newQuestions, error) in
            guard let self = self, let unwrappedQuestions = newQuestions, error == nil else {
                print("Error fetching trivia questions: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Now unwrappedQuestions is safely unwrapped and can be used
            self.questions = unwrappedQuestions
            // Make sure to refresh your UI here, e.g., reloading a table view or updating UI elements to display the first question
            // This might require calling another method or directly updating UI components on the main thread
            DispatchQueue.main.async {
                // For example, if you have a method to update the displayed question:
                self.updateQuestion(withQuestionIndex: 0)
            }
        }
    }
    
    

        
        
  
  private func updateQuestion(withQuestionIndex questionIndex: Int) {
    currentQuestionNumberLabel.text = "Question: \(questionIndex + 1)/\(questions.count)"
    let question = questions[questionIndex]
    questionLabel.text = question.question
    categoryLabel.text = question.category
    let answers = ([question.correctAnswer] + question.incorrectAnswers).shuffled()
      
      
      if question.incorrectAnswers.count == 1{
          answerButton0.setTitle("True", for: .normal)
          answerButton1.setTitle("False", for: .normal)
          answerButton2.isHidden = true
          answerButton3.isHidden = true
        
      }
      
      
    if answers.count > 0 {
      answerButton0.setTitle(answers[0], for: .normal)
    }
    if answers.count > 1 {
      answerButton1.setTitle(answers[1], for: .normal)
      answerButton1.isHidden = false
    }
    if answers.count > 2 {
      answerButton2.setTitle(answers[2], for: .normal)
      answerButton2.isHidden = false
    }
    if answers.count > 3 {
      answerButton3.setTitle(answers[3], for: .normal)
      answerButton3.isHidden = false
    }
      
  }
  
  private func updateToNextQuestion(answer: String) {
    if isCorrectAnswer(answer) {
      numCorrectQuestions += 1
    }
    currQuestionIndex += 1
    guard currQuestionIndex < questions.count else {
      showFinalScore()
      return
    }
    updateQuestion(withQuestionIndex: currQuestionIndex)
  }
  
  private func isCorrectAnswer(_ answer: String) -> Bool {
    return answer == questions[currQuestionIndex].correctAnswer
  }
  
  private func showFinalScore() {
    let alertController = UIAlertController(title: "Game over!",
                                            message: "Final score: \(numCorrectQuestions)/\(questions.count)",
                                            preferredStyle: .alert)
    let resetAction = UIAlertAction(title: "Restart", style: .default) { [unowned self] _ in
      currQuestionIndex = 0
      numCorrectQuestions = 0
      updateQuestion(withQuestionIndex: currQuestionIndex)
    }
    alertController.addAction(resetAction)
    present(alertController, animated: true, completion: nil)
  }
  
   
    
  private func addGradient() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = view.bounds
    gradientLayer.colors = [UIColor(red: 0.54, green: 0.88, blue: 0.99, alpha: 1.00).cgColor,
                            UIColor(red: 0.51, green: 0.81, blue: 0.97, alpha: 1.00).cgColor]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    view.layer.insertSublayer(gradientLayer, at: 0)
  }
  
  @IBAction func didTapAnswerButton0(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton1(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton2(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton3(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
}

