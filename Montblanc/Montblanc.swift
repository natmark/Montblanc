//
//  Montblanc.swift
//  Montblanc
//
//  Created by AtsuyaSato on 2018/07/19.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

import Foundation
import CoreML

public enum Result<T, E> {
    case success(T)
    case failure(E)
}

public enum MontblancError {
    case failedToCompile
    case failedToLocateCompiledModel
    case failedToDownload
    case failedToLocateDownloadedModel
    case unexpectedError
}

public struct Montblanc {
    static public func request(_ url: URL, _ block: @escaping (Result<MLModel, MontblancError>) -> Void) {
        Montblanc.fetch(url) { result in
            switch result {
            case .success(let path):
                block(Montblanc.compile(path))
            case .failure(let error):
                block(Result.failure(error))
            }
        }
    }

    static private func fetch(_ url: URL, _ block: @escaping (Result<URL, MontblancError>) -> Void) {
        let fileName = url.lastPathComponent

        guard var filePath = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else {
            block(Result.failure(.unexpectedError))
            return
        }

        filePath.appendPathComponent(fileName, isDirectory: false)

        if FileManager.default.fileExists(atPath: filePath.path) {
            block(Result.success(filePath))
            return
        }

        let task = URLSession.shared.downloadTask(with: url) {  (url, urlResponse, error) in
            if let _ = error {
                block(Result.failure(.failedToDownload))
                return
            }

            guard let url = url else {
                block(Result.failure(.failedToDownload))
                return
            }

            do {
                try FileManager.default.moveItem(at: url, to: filePath)
            } catch {
                block(Result.failure(.failedToLocateDownloadedModel))
                return
            }
            block(Result.success(filePath))
        }
        task.resume()
    }

    static public func compile(_ path: URL) -> Result<MLModel, MontblancError> {
        let compiledUrl: URL
        do {
            compiledUrl = try MLModel.compileModel(at: path)
        } catch {
            return Result.failure(.failedToCompile)
        }

        guard
            let directory = try? FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: compiledUrl,
                create: true
            ) else {
                return Result.failure(.unexpectedError)
        }

        let permanentUrl = directory.appendingPathComponent(compiledUrl.lastPathComponent, isDirectory: false)
        do {
            if FileManager.default.fileExists(atPath: permanentUrl.path) {
                _ = try FileManager.default.replaceItemAt(permanentUrl, withItemAt: compiledUrl)
            } else {
                try FileManager.default.copyItem(at: compiledUrl, to: permanentUrl)
            }
        } catch {
            return Result.failure(.failedToCompile)
        }

        do {
            let model = try MLModel(contentsOf: permanentUrl)
            return Result.success(model)
        } catch {
            return Result.failure(.failedToLocateCompiledModel)
        }
    }
}
