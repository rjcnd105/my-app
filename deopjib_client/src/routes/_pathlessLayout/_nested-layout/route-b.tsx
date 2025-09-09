import { View } from '@shared/ui/Templates/View'
import { createFileRoute } from '@tanstack/react-router'

export const Route = createFileRoute('/_pathlessLayout/_nested-layout/route-b')(
  {
    component: LayoutBComponent,
  },
)

function LayoutBComponent() {
  return <View transitionName="main">I'm B!</View>
}
