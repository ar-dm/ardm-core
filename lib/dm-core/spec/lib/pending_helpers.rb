module DataMapper
  module Spec
    module PendingHelpers

      def skip_if(*args)
        message, boolean = parse_args(*args)

        if boolean
          skip(message) { yield }
        else
          yield
        end
      end
      alias pending_if skip_if

      def rescue_if(*args)
        message, boolean = parse_args(*args)

        if boolean
          raised = nil
          begin
            yield
            raised = false
          rescue Exception
            raised = true
          end

          raise "should have raised: #{message || 'TODO'}" if raised == false
        else
          yield
        end
      end

      private

      def parse_args(*args)
        case args.map { |arg| arg.class }
          when [ String, TrueClass ], [ String, FalseClass ] then args
          when [ String, NilClass ]                          then [ args.first, false      ]
          when [ String ]                                    then [ args.first, true       ]
          when [ TrueClass ], [ FalseClass ]                 then [ '',         args.first ]
          when [ NilClass ]                                  then [ '',         false      ]
          when []                                            then [ '',         true       ]  # defaults
          else
            raise ArgumentError, "Invalid arguments: #{args.inspect}"
        end
      end

    end
  end
end
