module SignalFx
  module Tracing
    module Instrumenter
      module NetHttp

        Register.add_lib :NetHttp, self

        class << self

          def instrument(opts = {})
            begin
              require 'net/http/instrumentation'
            rescue LoadError => e
              puts e.message
              return
            end

            tracer = opts.fetch(:tracer, OpenTracing.global_tracer)
            ignore_request = lambda { Thread.current.thread_variable_get(:http_sender_thread) }
            ::Net::Http::Instrumentation.instrument(tracer: tracer, ignore_request: ignore_request) if !@instrumented
            @instrumented = true
          end
        end
      end
    end
  end
end
